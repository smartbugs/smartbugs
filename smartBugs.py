#!/usr/bin/env python3

import argparse
import git
import json
import os
import pathlib
import sys
import yaml

import datetime
from multiprocessing import Manager, Pool
from src.docker_api import analyse_files
import src.cli as cli
import src.config as config
from src.output_parser.SarifHolder import SarifHolder
import time


def analyse(args):
    global logs, output_folder

    (tool, file, sarif_outputs, import_path, output_version, nb_task, nb_task_done, total_execution, start_time) = args

    try:
        start = time.time()
        nb_task_done.value += 1

        sys.stdout.write(f'\x1b[1;37mAnalysing file [{nb_task_done.value}/{nb_task}]: \x1b[1;34m{file}\x1b[1;37m [{tool}] \x1b[0m\n')

        analyse_files(tool, file, logs, output_folder, sarif_outputs, output_version, import_path)
        end = time.time()

        total_execution.value +=  end - start

        duration = str(datetime.timedelta(seconds=round(end - start)))

        task_sec = nb_task_done.value / (end - start_time)
        remaining_time = str(datetime.timedelta(seconds=round((nb_task - nb_task_done.value) / task_sec)))

        sys.stdout.write(f'\x1b[1;37mDone [{nb_task_done.value}/{nb_task}, {remaining_time}]: \x1b[1;34m{file}\x1b[1;37m [{tool}] in {duration} \x1b[0m\n')
        logs.write(f'[{nb_task_done.value}/{nb_task}] {file} [{tool}] in {duration} \n')
    except Exception as e:
        print(e)
        raise e


def exec_cmd(args: argparse.Namespace):
    global logs, output_folder
    logs.write(f'Arguments passed: {sys.argv}\n')

    files_to_analyze = []

    if args.dataset:
        if args.dataset == ['all']:
            args.dataset = config.DATASET_CHOICES
        for dataset in args.dataset:
            base_name = dataset.split('/')[0]
            base_path = config.DATASETS[base_name]

            if config.is_remote_info(base_path):
                (url, base_path, subsets) = config.get_remote_info(base_path)
                global_path = os.path.join(config.DATASETS_PARENT, base_path)

                if os.path.isdir(base_path): # locally installed
                    sys.stdout.write(f'\x1b[1;37mUsing remote dataset [{base_path} <- {url}] \x1b[0m\n')
                elif os.path.isdir(global_path): # globally installed
                    base_path = global_path
                    sys.stdout.write(f'\x1b[1;37mUsing remote dataset [{base_path} <- {url}] \x1b[0m\n')
                else: # local copy does not exist; we need to clone it
                    print(f'\x1b[1;37m{base_name} is a remote dataset. Do you want to create a local copy? [Y/n] \x1b[0m')
                    answer = input()
                    if answer.lower() in ['yes', 'y', '']:
                        sys.stdout.write(f'\x1b[1;37mCloning remote dataset [{base_path} <- {url}]... \x1b[0m')
                        sys.stdout.flush()
                        git.Repo.clone_from(url, base_path)
                        sys.stdout.write('\x1b[1;37m\nDone.\x1b[0m\n')
                    else:
                        print(f'\x1b[1;33mABORTING: cannot proceed without local copy of remote dataset {base_name}\x1b[0m')
                        quit()

                if dataset == base_name:  # basename included
                    args.file.append(base_path)
                if dataset != base_name and base_name not in args.dataset:
                    subset_name = dataset.split('/')[1]
                    args.file.append(os.path.join(base_path, subsets[subset_name]))
            elif os.path.isdir(base_path): # locally installed
                args.file.append(base_path)
            else: # globally installed, hopefully
                global_path = os.path.join(config.DATASETS_PARENT, base_path)
                args.file.append(global_path)

    for file in args.file:
        # analyse files
        if os.path.basename(file).endswith('.sol'):
            files_to_analyze.append(file)
        # analyse dirs recursively
        elif os.path.isdir(file):
            if args.import_path == "FILE":
                args.import_path = file
            for root, dirs, files in os.walk(file):
                for name in files:
                    if name.endswith('.sol'):
                        # if its running on a windows machine
                        if os.name == 'nt':
                            files_to_analyze.append(os.path.join(root, name).replace('\\', '/'))
                        else:
                            files_to_analyze.append(os.path.join(root, name))
        else:
            print(f'{file} is not a directory or a solidity file')

    if args.tool == ['all']:
        args.tool = config.TOOL_CHOICES

    # Setting up analysis variables
    start_time = time.time()
    manager = Manager()

    nb_task_done = manager.Value('i', 0)
    total_execution = manager.Value('f', 0)
    nb_task = len(files_to_analyze) * len(args.tool)

    sarif_outputs = manager.dict()
    tasks = []
    file_names = []
    for file in files_to_analyze:
        for tool in args.tool:
            results_folder = os.path.join('results', tool, output_folder)
            if not os.path.exists(results_folder):
                os.makedirs(results_folder)

            if args.skip_existing:
                file_name = os.path.splitext(os.path.basename(file))[0]
                folder = os.path.join(results_folder, file_name, 'result.json')
                if os.path.exists(folder):
                    continue

            tasks.append((tool, file, sarif_outputs, args.import_path, args.output_version, nb_task, nb_task_done,
                          total_execution, start_time))
        file_names.append(os.path.splitext(os.path.basename(file))[0])

    # initialize all sarif outputs
    for file_name in file_names:
        sarif_outputs[file_name] = SarifHolder()

    with Pool(processes=args.processes) as pool:
        pool.map(analyse, tasks)

    if args.aggregate_sarif:
        sarif_aggregate_folder = os.path.join('results', output_folder)
        if not os.path.exists(sarif_aggregate_folder):
                os.makedirs(sarif_aggregate_folder)
        for file_name in file_names:
            sarif_file_path = os.path.join(sarif_aggregate_folder, f'{file_name}.sarif')
            with open(sarif_file_path, 'w') as sarif_file:
                json.dump(sarif_outputs[file_name].print(), sarif_file, indent=2)

    if args.unique_sarif_output:
        sarif_holder = SarifHolder()
        for sarif_output in sarif_outputs.values():
            for run in sarif_output.sarif.runs:
                sarif_holder.addRun(run)
        sarif_file_path = os.path.join('results', f'{output_folder}.sarif')
        with open(sarif_file_path, 'w') as sarif_file:
            json.dump(sarif_holder.print(), sarif_file, indent=2)


if __name__ == '__main__':
    start_time = time.time()
    args = cli.create_parser()
    output_folder = args.execution_name
    log_path = os.path.join('results', 'logs')
    pathlib.Path(log_path).mkdir(parents=True, exist_ok=True)
    log_file = os.path.join(log_path, f'SmartBugs_{output_folder}.log')
    logs = open(log_file, 'w')
    exec_cmd(args)
    elapsed_time = round(time.time() - start_time)
    if elapsed_time > 60:
        elapsed_time_sec = round(elapsed_time % 60)
        elapsed_time = round(elapsed_time // 60)
        print(f'Analysis completed. \nIt took {elapsed_time}m {elapsed_time_sec}s to analyse all files.')
        logs.write(f'Analysis completed. \nIt took {elapsed_time}m {elapsed_time_sec}s to analyse all files.')
    else:
        print(f'Analysis completed. \nIt took {elapsed_time}s to analyse all files.')
        logs.write(f'Analysis completed. \nIt took {elapsed_time}s to analyse all files.')
