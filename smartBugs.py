#!/usr/bin/env python3

import argparse
import git
import json
import os
import pathlib
import sys
import yaml

from datetime import timedelta
from multiprocessing import Manager, Pool
from src.docker_api.docker_api import analyse_files
from src.interface.cli import create_parser, getRemoteDataset, isRemoteDataset, DATASET_CHOICES, TOOLS_CHOICES
from src.output_parser.SarifHolder import SarifHolder
from time import time, localtime, strftime


cfg_dataset_path = os.path.abspath('config/dataset/dataset.yaml')
with open(cfg_dataset_path, 'r') as ymlfile:
    try:
        cfg_dataset = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        print(exc)

output_folder = strftime("%Y%m%d_%H%M", localtime())
pathlib.Path('results/logs/').mkdir(parents=True, exist_ok=True)
logs = open('results/logs/SmartBugs_' + output_folder + '.log', 'w')


def analyse(args):
    global logs, output_folder

    (tool, file, sarif_outputs, import_path, output_version, nb_task, nb_task_done, total_execution, start_time) = args

    try:
        start = time()
        nb_task_done.value += 1

        sys.stdout.write('\x1b[1;37m' + 'Analysing file [%d/%d]: ' % (nb_task_done.value, nb_task) + '\x1b[0m')
        sys.stdout.write('\x1b[1;34m' + file + '\x1b[0m')
        sys.stdout.write('\x1b[1;37m' + ' [' + tool + ']' + '\x1b[0m' + '\n')

        analyse_files(tool, file, logs, output_folder, sarif_outputs, output_version, import_path)


        total_execution.value += time() - start

        duration = str(timedelta(seconds=round(time() - start)))

        task_sec = nb_task_done.value / (time() - start_time)
        remaining_time = str(timedelta(seconds=round((nb_task - nb_task_done.value) / task_sec)))

        sys.stdout.write(
            '\x1b[1;37m' + 'Done [%d/%d, %s]: ' % (nb_task_done.value, nb_task, remaining_time) + '\x1b[0m')
        sys.stdout.write('\x1b[1;34m' + file + '\x1b[0m')
        sys.stdout.write('\x1b[1;37m' + ' [' + tool + '] in ' + duration + ' ' + '\x1b[0m' + '\n')
        logs.write('[%d/%d] ' % (nb_task_done.value, nb_task) + file + ' [' + tool + '] in ' + duration + ' \n')
    except Exception as e:
        print(e)
        raise e


def exec_cmd(args: argparse.Namespace):
    global logs, output_folder
    logs.write('Arguments passed: ' + str(sys.argv) + '\n')

    files_to_analyze = []

    if args.dataset:
        if args.dataset == ['all']:
            DATASET_CHOICES.remove('all')
            args.dataset = DATASET_CHOICES
        for dataset in args.dataset:
            # Directory search is recursive (see below), so
            # if a remote D is used, we don't need to specify
            # the subsets of D
            base_name = dataset.split('/')[0]
            if isRemoteDataset(cfg_dataset, base_name):
                remote_info = getRemoteDataset(cfg_dataset, base_name)
                base_path = remote_info['local_dir']

                if not os.path.isdir(base_path):
                    # local copy does not exist; we need to clone it
                    print(
                        '\x1b[1;37m' + "%s is a remote dataset. Do you want to create a local copy? [Y/n] " % base_name + '\x1b[0m')
                    answer = input()
                    if answer.lower() in ['yes', 'y', '']:
                        sys.stdout.write('\x1b[1;37m' + 'Cloning remote dataset [%s <- %s]... ' % (
                            base_path, remote_info['url']) + '\x1b[0m')
                        sys.stdout.flush()
                        git.Repo.clone_from(remote_info['url'], base_path)
                        sys.stdout.write('\x1b[1;37m\n' + 'Done.' + '\x1b[0m\n')
                    else:
                        print(
                            '\x1b[1;33m' + 'ABORTING: cannot proceed without local copy of remote dataset %s' % base_name + '\x1b[0m')
                        quit()
                else:
                    sys.stdout.write('\x1b[1;37m' + 'Using remote dataset [%s <- %s] ' % (
                        base_path, remote_info['url']) + '\x1b[0m\n')

                if dataset == base_name:  # basename included
                    dataset_path = base_path
                    args.file.append(dataset_path)
                if dataset != base_name and base_name not in args.dataset:
                    sbset_name = dataset.split('/')[1]
                    dataset_path = os.path.join(base_path, remote_info['subsets'][sbset_name])
                    args.file.append(dataset_path)
            else:
                dataset_path = cfg_dataset[dataset]
                args.file.append(dataset_path)

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
            print('%s is not a directory or a solidity file' % file)

    if args.tool == ['all']:
        TOOLS_CHOICES.remove('all')
        args.tool = TOOLS_CHOICES

    # Setting up analysis variables
    start_time = time()
    manager = Manager()

    nb_task_done = manager.Value('i', 0)
    total_execution = manager.Value('f', 0)
    nb_task = len(files_to_analyze) * len(args.tool)

    sarif_outputs = manager.dict()
    tasks = []
    file_names = []
    for file in files_to_analyze:
        for tool in args.tool:
            results_folder = 'results/' + tool + '/' + output_folder
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
        for file_name in file_names:
            sarif_file_path = 'results/' + output_folder + '/' + file_name + '.sarif'
            with open(sarif_file_path, 'w') as sarif_file:
                json.dump(sarif_outputs[file_name].print(), sarif_file, indent=2)

    if args.unique_sarif_output:
        sarif_holder = SarifHolder()
        for sarif_output in sarif_outputs.values():
            for run in sarif_output.sarif.runs:
                sarif_holder.addRun(run)
        sarif_file_path = 'results/' + output_folder + '.sarif'
        with open(sarif_file_path, 'w') as sarif_file:
            json.dump(sarif_holder.print(), sarif_file, indent=2)

    return logs


if __name__ == '__main__':
    start_time = time()
    args = create_parser()
    logs = exec_cmd(args)
    elapsed_time = round(time() - start_time)
    if elapsed_time > 60:
        elapsed_time_sec = round(elapsed_time % 60)
        elapsed_time = round(elapsed_time // 60)
        print('Analysis completed. \nIt took %sm %ss to analyse all files.' % (elapsed_time, elapsed_time_sec))
        logs.write('Analysis completed. \nIt took %sm %ss to analyse all files.' % (elapsed_time, elapsed_time_sec))
    else:
        print('Analysis completed. \nIt took %ss to analyse all files.' % elapsed_time)
        logs.write('Analysis completed. \nIt took %ss to analyse all files.' % elapsed_time)
