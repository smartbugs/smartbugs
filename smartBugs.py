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


def analyze(file, id, tool, results_folder, import_path, output_version, n_processes, n_tasks):
    with tasks_started.get_lock():
        tasks_started.value += 1
        n_started = tasks_started.value
    log.message(f"Analyzing file [{n_started}/{n_tasks}]: {col.file(file)} [{col.tool(tool['name'])}]", None)

    results, result_log, result_tar = docker_api.run(file, tool, results_folder)
    parsing.parse_results(results, result_log, result_tar, results_folder, sarif_outputs, id, import_path, output_version)

    with total_time.get_lock():
        total_time.value += results["duration"]
        total = total_time.value
    duration = datetime.timedelta(seconds=round(results["duration"]))
    with tasks_completed.get_lock():
        tasks_completed.value += 1
        n_completed = tasks_completed.value
    if n_completed >= 3*n_processes: # make prediction more reliable; still sucks because of timeouts
        # estimated time to completion = avg.time per task * remaining tasks / no.processes
        etc = (total/n_completed) * (n_tasks-n_completed) / n_processes
        etc = f", ETC {datetime.timedelta(seconds=round(etc))}"
    else:
        etc = ''
    log.message(
        f"Done [{n_completed}/{n_tasks}{etc}]: {col.file(file)} [{col.tool(tool['name'])}] in {duration}",
        f"[{n_completed}/{n_tasks}] {file} [{tool['name']}] in {duration}")


def process_datasets(context):
    if 'dataset' not in context or not context['dataset']:
        return
    if 'all' in context['dataset']:
        context['dataset'] = config.DATASET_CHOICES

    for dataset in context['dataset']:
        base_name = dataset.split('/')[0]
        base_path = config.DATASETS[base_name]

        if config.is_remote_info(base_path):
            (url, base_path, subsets) = config.get_remote_info(base_path)
            global_path = os.path.join(config.DATASETS_PARENT, base_path)

            if os.path.isdir(base_path): # locally installed
                log.message(f"Using remote dataset [{base_path} <- {url}]")
            elif os.path.isdir(global_path): # globally installed
                log.message(f"Using remote dataset [{global_path} <- {url}]")
                base_path = global_path
            else: # local copy does not exist; we need to clone it
                #time.sleep(1)
                answer = input(f"{base_name} is a remote dataset. Do you want to create a local copy? [Y/n] ").strip()
                if answer.lower() in ['yes', 'y', '']:
                    print(f"Cloning remote dataset [{base_path} <- {url}]... ", flush=True, end='')
                    git.Repo.clone_from(url, base_path)
                    print("Done.", flush=True)
                else:
                    log.message(col.error(f"ABORTING: cannot proceed without local copy of remote dataset {base_name}"))
                    sys.exit(1)

            if dataset == base_name:  # basename included
                context["file"].append(base_path)
            if dataset != base_name and base_name not in context["dataset"]:
                subset_name = dataset.split('/')[1]
                context["file"].append(os.path.join(base_path, subsets[subset_name]))
        elif os.path.isdir(base_path): # locally installed
            context["file"].append(base_path)
        else: # globally installed, hopefully
            global_path = os.path.join(config.DATASETS_PARENT, base_path)
            context["file"].append(global_path)


def collect_files(context):
    files_to_analyze = set()
    for file in context["file"]:
        if os.path.basename(file).endswith('.sol'):
            files_to_analyze.add(file)
        # analyse dirs recursively
        elif os.path.isdir(file):
            if context["import_path"] == "FILE":
                context["import_path"] = file
            for root, dirs, files in os.walk(file):
                for name in files:
                    if name.endswith('.sol'):
                        # if its running on a windows machine
                        if os.name == 'nt':
                            files_to_analyze.add(os.path.join(root, name).replace('\\', '/'))
                        else:
                            files_to_analyze.add(os.path.join(root, name))
        else:
            log.message(col.warning(f"{file} is neither a directory nor a solidity file"))

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


def collect_tools(context):
    if 'all' in context["tool"]:
        context["tool"] = config.TOOL_CHOICES
    tools_to_use = []
    for toolname in context["tool"]:
        tool_folder = os.path.join('results', toolname, context["execution_name"])
        os.makedirs(tool_folder, exist_ok=True)
        tool = config.TOOLS[toolname]
        if "docker_image" not in tool or tool["docker_image"] == None:
            log.message(col.error(f"{toolname}: docker image not provided, check you config file."))
            sys.exit(1)
        image = tool["docker_image"]
        docker_api.pull_image(image)
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


def allocate_shared_memory(files_to_analyze):
    global sarif_outputs, tasks_started, tasks_completed, total_time
    manager = multiprocessing.Manager()
    sarif_outputs = manager.dict()
    for _,id in files_to_analyze:
        sarif_outputs[id] = SarifHolder.SarifHolder()
    tasks_started = multiprocessing.Value('L', 0)
    tasks_completed = multiprocessing.Value('L', 0)
    total_time = multiprocessing.Value('f', 0.0)


def aggregate_sarif(context):
    if not context["aggregate_sarif"]:
        return
    sarif_folder = os.path.join("results", context["execution_name"])
    os.makedirs(sarif_folder, exist_ok=True)
    for id in sarif_outputs:
        with open(os.path.join(sarif_folder,f"{id}.sarif"), "w") as sarif_file:
            json.dump(sarif_outputs[id].print(), sarif_file, indent=2, sort_keys=True)


def unique_sarif(context):
    if not context["unique_sarif_output"]:
        return
    sarif_holder = SarifHolder.SarifHolder()
    for sarif_output in sarif_outputs.values():
        for run in sarif_output.sarif.runs:
            sarif_holder.addRun(run)
    sarif_file_path = os.path.join("results", f"{context['execution_name']}.sarif")
    with open(sarif_file_path, 'w') as sarif_file:
        json.dump(sarif_holder.print(), sarif_file, indent=2, sort_keys=True)


def smartbugs(context):
    log.start(context["execution_name"], append=context["skip_existing"])
    try:
        # greeting
        log.message(col.success("Welcome to SmartBugs!"), f"Arguments passed: {sys.argv}")
        start_time = time.time()

        # preparation
        process_datasets(context)
        files_to_analyze = collect_files(context)
        tools_to_use     = collect_tools(context)
        tasks            = collect_tasks(files_to_analyze, tools_to_use, context["skip_existing"])
        constants        = (context["import_path"], context["output_version"], context["processes"], len(tasks))

        # parallelized execution
        allocate_shared_memory(files_to_analyze)
        random.shuffle(tasks)
        args = [ task + constants for task in tasks ]
        with multiprocessing.Pool(processes=context["processes"]) as pool:
            pool.starmap(analyze, args)

        # post-processing
        aggregate_sarif(context)
        unique_sarif   (context)

        # good bye
        duration = datetime.timedelta(seconds=round(time.time()-start_time))
        log.message(f"Analysis completed. \nIt took {duration} to analyse all files.")
    finally:
        log.stop()


if __name__ == '__main__':
    smartbugs(cli.arguments())
