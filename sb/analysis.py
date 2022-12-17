import multiprocessing, random, time, datetime, os
import sb.logging, sb.colors, sb.docker, sb.cfg, sb.io, sb.parsing, sb.sarif
from sb.exceptions import SmartBugsError



def task_log_dict(task, start_time, duration, exit_code, log, output, docker_args):
    return {
        "filename": task.relfn,
        "runid": task.settings.runid,
        "result": {
            "start": start_time,
            "duration": duration,
            "exit_code": exit_code,
            "logs": sb.cfg.TOOL_LOG if log else None,
            "output": sb.cfg.TOOL_OUTPUT if output else None},
        "solc": str(task.solc_version) if task.solc_version else None,
        "tool": task.tool.dict(),
        "docker": docker_args,
        "platform": sb.cfg.PLATFORM,
    }



def execute(task):

    # create result dir if it doesn't exist
    os.makedirs(task.rdir, exist_ok=True)
    if not os.path.isdir(task.rdir):
        raise SmartBugsError(f"Cannot create result directory {task.rdir}")

    # check whether result dir is empty,
    # and if not, whether we are going to overwrite it
    fn_task_log = os.path.join(task.rdir, sb.cfg.TASK_LOG)
    if os.path.exists(fn_task_log):
        old = sb.io.read_json(fn_task_log)
        old_fn = old["filename"]
        old_toolid = old["tool"]["id"]
        old_mode = old["tool"]["mode"]
        if task.relfn != old_fn or task.tool.id != old_toolid or task.tool.mode != old_mode:
            raise SmartBugsError(
                f"Result directory {task.rdir} occupied by another task"
                f" ({old_toolid}/{old_mode}, {old_fn})")
        if not task.settings.overwrite:
            return 0.0

    # remove any leftovers from a previous analysis
    fn_tool_log = os.path.join(task.rdir, sb.cfg.TOOL_LOG)
    fn_tool_output = os.path.join(task.rdir, sb.cfg.TOOL_OUTPUT)
    fn_parser_output = os.path.join(task.rdir, sb.cfg.PARSER_OUTPUT)
    fn_sarif_output = os.path.join(task.rdir, sb.cfg.SARIF_OUTPUT)
    for fn in (fn_task_log, fn_tool_log, fn_tool_output, fn_parser_output, fn_sarif_output):
        try:
            os.remove(fn)
        except:
            pass
        if os.path.exists(fn):
            raise SmartBugsError(f"Cannot clear old output {fn}")

    # perform analysis
    start_time = time.time()
    exit_code,tool_log,tool_output,docker_args = sb.docker.execute(task)
    duration = time.time() - start_time

    # write result to files
    task_log = task_log_dict(task, start_time, duration, exit_code, tool_log, tool_output, docker_args)
    sb.io.write_json(fn_task_log, task_log)
    if tool_log:
        sb.io.write_txt(fn_tool_log, tool_log)
    if tool_output:
        sb.io.write_bin(fn_tool_output, tool_output)
        
    # Parse output of tool
    if task.settings.json or task.settings.sarif:
        parsed_result = sb.parsing.parse(task_log, tool_log, tool_output)
        sb.io.write_json(fn_parser_output,parsed_result)

        # Format parsed result as sarif
        if task.settings.sarif:
            sarif_result = sb.sarif.sarify(task_log["tool"], parsed_result["findings"])
            sb.io.write_json(fn_sarif_output, sarif_result)       

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
    sb.logging.start(settings.log, settings.overwrite, logqueue)
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

