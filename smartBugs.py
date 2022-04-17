#!/usr/bin/env python3

import os, sys, multiprocessing, json, datetime, time, hashlib, random
import git

import src.docker_api as docker_api
import src.cli as cli
import src.config as config
import src.logging as log
import src.colors as col
import src.parsing as parsing
import src.output_parser.SarifHolder as SarifHolder


def process_datasets(logqueue, settings):
    if 'dataset' not in settings or not settings['dataset']:
        return
    if 'all' in settings['dataset']:
        settings['dataset'] = config.DATASET_CHOICES

    for dataset in settings['dataset']:
        base_name = dataset.split('/')[0]
        base_path = config.DATASETS[base_name]

        if config.is_remote_info(base_path):
            (url, base_path, subsets) = config.get_remote_info(base_path)
            global_path = os.path.join(config.DATASETS_PARENT, base_path)

            if os.path.isdir(base_path): # locally installed
                log.message(logqueue, f"Using remote dataset [{base_path} <- {url}]")
            elif os.path.isdir(global_path): # globally installed
                log.message(logqueue, f"Using remote dataset [{global_path} <- {url}]")
                base_path = global_path
            else: # local copy does not exist; we need to clone it
                time.sleep(1)
                answer = input(f"{base_name} is a remote dataset. Do you want to create a local copy? [Y/n] ").strip()
                if answer.lower() in ['yes', 'y', '']:
                    print(f"Cloning remote dataset [{base_path} <- {url}]... ", flush=True, end='')
                    git.Repo.clone_from(url, base_path)
                    print("Done.", flush=True)
                else:
                    log.message(logqueue, col.error(f"ABORTING: cannot proceed without local copy of remote dataset {base_name}"))
                    sys.exit(1)

            if dataset == base_name:  # basename included
                settings["file"].append(base_path)
            if dataset != base_name and base_name not in settings["dataset"]:
                subset_name = dataset.split('/')[1]
                settings["file"].append(os.path.join(base_path, subsets[subset_name]))
        elif os.path.isdir(base_path): # locally installed
            settings["file"].append(base_path)
        else: # globally installed, hopefully
            global_path = os.path.join(config.DATASETS_PARENT, base_path)
            settings["file"].append(global_path)


def collect_files(logqueue, settings):
    files_to_analyze = set()
    for file in settings["file"]:
        if os.path.basename(file).endswith('.sol'):
            files_to_analyze.add(file)
        # analyse dirs recursively
        elif os.path.isdir(file):
            if settings["import_path"] == "FILE":
                settings["import_path"] = file
            for root, dirs, files in os.walk(file):
                for name in files:
                    if name.endswith('.sol'):
                        # if its running on a windows machine
                        if os.name == 'nt':
                            files_to_analyze.add(os.path.join(root, name).replace('\\', '/'))
                        else:
                            files_to_analyze.add(os.path.join(root, name))
        else:
            log.message(logqueue, col.warning(f"{file} is neither a directory nor a solidity file"))

    # Use base name as file id if unique, otherwise append md5hash of full file name
    clashes = set()
    ids = set()
    file_ids = []
    for file in files_to_analyze:
        id = os.path.splitext(os.path.basename(file))[0]
        file_ids.append((file,id))
        if id in ids:
            clashes.add(id)
        else:
            ids.add(id)

    files_to_analyze = []
    for file, id in file_ids:
        if id in clashes:
            files_to_analyze.append((file,f"{id}.{hashlib.md5(file).hexdigest()[0:8]}"))
        else:
            files_to_analyze.append((file,id))
    return files_to_analyze


def collect_tools(logqueue, settings):
    if 'all' in settings["tool"]:
        settings["tool"] = config.TOOL_CHOICES
    tools_to_use = []
    for toolname in settings["tool"]:
        tool_folder = os.path.join('results', toolname, settings["execution_name"])
        os.makedirs(tool_folder, exist_ok=True)
        tool = config.TOOLS[toolname]
        if "docker_image" not in tool or tool["docker_image"] == None:
            log.message(logqueue, col.error(f"{toolname}: docker image not provided, check you config file."))
            sys.exit(1)
        image = tool["docker_image"]
        docker_api.pull_image(logqueue, image)
        tools_to_use.append((tool,tool_folder))
    return tools_to_use


def collect_tasks(files_to_analyze, tools_to_use, skip_existing):
    tasks = []
    for file,id in files_to_analyze:
        for tool,tool_folder in tools_to_use:
            results_folder = os.path.join(tool_folder, id)
            os.makedirs(results_folder, exist_ok=True)
            if skip_existing and os.path.exists(os.path.join(results_folder,'result.json')):
                continue
            tasks.append((file, id, tool, results_folder))
    return tasks


def analyzer(logqueue, taskqueue, sarifqueue, tasks_started, tasks_completed, total_time,
        import_path, output_version, n_processes, n_tasks):
    while True:
        task = taskqueue.get()
        if task is None:
            return
        (file, id, tool, results_folder) = task
        
        with tasks_started.get_lock():
            tasks_started.value += 1
            n_started = tasks_started.value
        log.message(logqueue, f"Analyzing file [{n_started}/{n_tasks}]: {col.file(file)} [{col.tool(tool['name'])}]", None)

        results, result_log, result_tar = docker_api.run(logqueue, file, tool, results_folder)

        try:
            results, sarif = parsing.parse_results(logqueue, results, result_log, result_tar, import_path)
            if output_version in ("v1", "all"):
                with open(os.path.join(results_folder, 'result.json'), 'w') as f:
                    json.dump(results, f, indent=2, sort_keys=True)
            if sarif is not None:
                sarifqueue.put((id, tool["name"], sarif, results_folder))
        except Exception as err:
            log.message(logqueue, col.error(f"Error parsing output of {tool['name']} for file {file}\n{err}"))

        with total_time.get_lock(), tasks_completed.get_lock(), tasks_started.get_lock():
            total_time.value += results["duration"]
            total = total_time.value
            tasks_completed.value += 1
            n_completed = tasks_completed.value
            n_started = tasks_started.value

        # estimated time to completion = avg.time per task * remaining tasks / no.processes
        # we assume that the tasks that have started but haven't yet completed run into a timeout
        timeout = 30 * 60 
        etc = (total+(n_started-n_completed)*timeout) / n_started * (n_tasks-n_completed) / n_processes
        etc = datetime.timedelta(seconds=round(etc))
        duration = datetime.timedelta(seconds=round(results["duration"]))
        log.message(logqueue,
            f"Done [{n_completed}/{n_tasks}, ETC {etc}]: {col.file(file)} [{col.tool(tool['name'])}] in {duration}",
            f"[{n_completed}/{n_tasks}] {file} [{tool['name']}] in {duration}")


def sarif_collector(sarifqueue, execution_name, output_version, aggregate_sarif, unique_sarif_output):
    sarif_outputs = {}
    while True:
        run = sarifqueue.get()
        if run is None:
            break
        id, toolname, sarif, results_folder = run

        if output_version in ("v2","all"):
            with open(os.path.join(results_folder, "result.sarif"), "w") as f:
                sarif_holder = SarifHolder.SarifHolder()
                sarif_holder.addRun(sarif)
                json.dump(sarif_holder.printToolRun(tool=toolname), f, indent=2, sort_keys=True)

        if id in sarif_outputs:
            sarif_holder = sarif_outputs[id]
        else:
            sarif_holder = SarifHolder.SarifHolder()
        sarif_holder.addRun(sarif)
        sarif_outputs[id] = sarif_holder

    if aggregate_sarif:
        sarif_folder = os.path.join("results", execution_name)
        os.makedirs(sarif_folder, exist_ok=True)
        for id in sarif_outputs:
            with open(os.path.join(sarif_folder,f"{id}.sarif"), "w") as sarif_file:
                json.dump(sarif_outputs[id].print(), sarif_file, indent=2, sort_keys=True)

    if unique_sarif_output:
        sarif_holder = SarifHolder.SarifHolder()
        for sarif_output in sarif_outputs.values():
            for run in sarif_output.sarif.runs:
                sarif_holder.addRun(run)
        sarif_file_path = os.path.join("results", f"{execution_name}.sarif")
        with open(sarif_file_path, 'w') as sarif_file:
            json.dump(sarif_holder.print(), sarif_file, indent=2, sort_keys=True)


def smartbugs(settings):
    # spawn processes (instead of forking), to obtain the same behavior on Linux and MacOS
    mp = multiprocessing.get_context("spawn")
    # shared memory
    logqueue = mp.Queue()
    taskqueue = mp.Queue()
    sarifqueue = mp.Queue()
    tasks_started = mp.Value('L', 0)
    tasks_completed = mp.Value('L', 0)
    total_time = mp.Value('f', 0.0)

    # start shared logging
    log.start(logqueue, settings["execution_name"], append=settings["skip_existing"])
    try:
        log.message(logqueue, col.success("Welcome to SmartBugs!"), f"Arguments passed: {sys.argv}")
        start_time = time.time()

        # preparation
        process_datasets(logqueue, settings)
        files_to_analyze = collect_files(logqueue, settings)
        tools_to_use     = collect_tools(logqueue, settings)
        tasks            = collect_tasks(files_to_analyze, tools_to_use, settings["skip_existing"])

        # parallel execution
        # fill task queue, add sentinels to stop analyzers
        random.shuffle(tasks)
        for task in tasks:
            taskqueue.put(task)
        for _ in range(settings["processes"]):
            taskqueue.put(None)

        # set up and start analyzers
        shared = (logqueue, taskqueue, sarifqueue, tasks_started, tasks_completed, total_time)
        constants = (settings["import_path"], settings["output_version"], settings["processes"], len(tasks))
        analyzers = [ mp.Process(target=analyzer, args=shared+constants) for _ in range(settings["processes"]) ]
        for a in analyzers:
            a.start()

        # set up and start sarif collector
        constants = (settings["execution_name"],settings["output_version"], settings["aggregate_sarif"],settings["unique_sarif_output"])
        collector = mp.Process(target=sarif_collector, args=(sarifqueue,)+constants)
        collector.start()

        # wait for analyzers to finish
        for a in analyzers:
            a.join()

        # wait for sarif collector to finish
        sarifqueue.put(None)
        collector.join()

        # good bye
        duration = datetime.timedelta(seconds=round(time.time()-start_time))
        log.message(logqueue, f"Analysis completed. \nIt took {duration} to analyse all files.")
    finally:
        log.stop(logqueue)


if __name__ == '__main__':
    smartbugs(cli.arguments())
