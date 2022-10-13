import multiprocessing, random, time, datetime, os, cpuinfo, platform
import sb.logging, sb.colors, sb.docker, sb.config, sb.io
from sb.exceptions import SmartBugsError


cpu = cpuinfo.get_cpu_info()
python_version = cpu["python_version"]
del cpu["flags"]
del cpu["python_version"]
SYSTEM_INFO = {
    "smartbugs": {
        "version": sb.config.VERSION,
        "python": python_version
    },
    "platform": platform.uname()._asdict(),
    "cpu_info": cpu
}

def task_info(task, start_time, docker_args, exit_code, log, output, duration):
    info = {
        "contract": {
            "abs_filename": task.absfn,
            "filename": task.relfn},
        "result": {
            "start": start_time,
            "duration": duration,
            "exit_code": exit_code,
            "logs": sb.config.TOOL_LOG if log else None,
            "output": sb.config.TOOL_OUTPUT if output else None},
        "solc": {
            "version": str(task.solc_version),
            "path": str(task.solc_path) },
        "tool": task.tool.dict(),
        "docker": docker_args,
    }
    info.update(SYSTEM_INFO)
    return info



def execute(task):

    os.makedirs(task.rdir, exist_ok=True)
    if not os.path.isdir(task.rdir):
        raise SmartBugsError(f"Cannot create result directory {task.rdir}")

    task_log = os.path.join(task.rdir, sb.config.TASK_LOG)
    if os.path.exists(task_log):
        old = sb.io.read_json(task_log)
        old_absfn = old["contract"]["abs_filename"]
        old_toolid = old["tool"]["id"]
        old_mode = old["tool"]["mode"]
        if task.absfn != old_absfn or task.tool.id != old_toolid or task.tool.mode != old_mode:
            raise SmartBugsError(
                f"Result directory {task.rdir} occupied by another task"
                f" ({old_toolid}/{old_mode}, {old_absfn})")
        if not task.settings.overwrite:
            return 0.0

    tool_log = os.path.join(task.rdir, sb.config.TOOL_LOG)
    tool_output = os.path.join(task.rdir, sb.config.TOOL_OUTPUT)
    for old in (task_log, tool_log, tool_output):
        try:
            os.remove(old)
        except:
            pass
        if os.path.exists(old):
            raise SmartBugsError(f"Cannot clear old output {old}")

    start_time = time.time()
    docker_args,exit_code,log,output = sb.docker.execute(task)
    duration = time.time() - start_time

    sb.io.write_json(task_log, task_info(task, start_time, docker_args, exit_code, log, output, duration))
    if log:
        sb.io.write_txt(tool_log, log)
    if output:
        sb.io.write_bin(tool_output, output)

    return duration



def analyser(logqueue, taskqueue, tasks_total, tasks_started, tasks_completed, time_completed):
        
    def pre_analysis():
        with tasks_started.get_lock():
            tasks_started.value += 1
            started = tasks_started.value
        sb.logging.message(
            f"Starting task {started}/{tasks_total}: {sb.colors.tool(task.tool.id)} and {sb.colors.file(task.relfn)}",
            "", logqueue)

    def post_analysis(duration):
        with tasks_completed.get_lock(), time_completed.get_lock():
            tasks_completed.value += 1
            time_completed.value += duration
            elapsed = time_completed.value
            completed = tasks_completed.value
        # estimated time to completion = avg.time per task * remaining tasks / no.processes
        etc = elapsed / completed * (tasks_total-completed) / task.settings.processes
        etc_fmt = datetime.timedelta(seconds=round(etc))
        duration_fmt = datetime.timedelta(seconds=round(duration))
        sb.logging.message(f"{completed}/{tasks_total} completed, ETC {etc_fmt}")

    while True:
        task = taskqueue.get()
        if task is None:
            return
        sb.logging.quiet = task.settings.quiet
        pre_analysis()
        try:
            duration = execute(task)
        except SmartBugsError as e:
            duration = 0
            sb.logging.message(sb.colors.error(f"Analysis of {task.absfn} with {task.tool.id} failed.\n{e}"), "", logqueue)
        post_analysis(duration)



def run(tasks, settings):
    # spawn processes (instead of forking), for identical behavior on Linux and MacOS
    mp = multiprocessing.get_context("spawn")

    # start shared logging
    logqueue = mp.Queue()
    sb.logging.start(settings.logfile, settings.overwrite, logqueue)
    try:
        start_time = time.time()

        # fill task queue
        taskqueue = mp.Queue()
        random.shuffle(tasks)
        for task in tasks:
            taskqueue.put(task)
        for _ in range(settings.processes):
            taskqueue.put(None)

        # accounting
        tasks_total = len(tasks)
        tasks_started = mp.Value('L', 0)
        tasks_completed = mp.Value('L', 0)
        time_completed = mp.Value('f', 0.0)

        # start analysers
        shared = (logqueue, taskqueue, tasks_total, tasks_started, tasks_completed, time_completed)
        analysers = [ mp.Process(target=analyser, args=shared) for _ in range(settings.processes) ]
        for a in analysers:
            a.start()

        # wait for analysers to finish
        for a in analysers:
            a.join()

        # good bye
        duration = datetime.timedelta(seconds=round(time.time()-start_time))
        sb.logging.message(f"Analysis completed in {duration}.", "", logqueue)

    finally:
        sb.logging.stop(logqueue)

