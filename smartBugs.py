#!/usr/bin/env python3

import argparse
import git
import os
import pathlib
import sys
import yaml
from time import localtime, strftime

from src.execution.execution import Execution
from src.execution.execution_task import Execution_Task
from src.execution.execution_configuration import Execution_Configuration
from src.logger import logs
from src.interface.cli import create_parser, get_remote_dataset, is_remote_dataset, DATASET_CHOICES, TOOLS_CHOICES


cfg_dataset_path = os.path.abspath('config/dataset/dataset.yaml')
with open(cfg_dataset_path, 'r') as ymlfile:
    try:
        cfg_dataset = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        logs.print(exc)


def create_tasks(conf: Execution_Configuration, args: argparse.Namespace) -> list[Execution_Task]:
    files_to_analyze = []

    if args.tool == ['all']:
        TOOLS_CHOICES.remove('all')
        args.tool = TOOLS_CHOICES

    if args.dataset:
        if args.dataset == ['all']:
            DATASET_CHOICES.remove('all')
            args.dataset = DATASET_CHOICES
        for dataset in args.dataset:
            base_name = dataset.split('/')[0]
            if is_remote_dataset(cfg_dataset, base_name):
                remote_info = get_remote_dataset(cfg_dataset, base_name)
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
                        sys.stdout.write(
                            '\x1b[1;37m\n' + 'Done.' + '\x1b[0m\n')
                    else:
                        logs.print(
                            '\x1b[1;33m' + 'ABORTING: cannot proceed without local copy of remote dataset %s' % base_name + '\x1b[0m')
                        quit()
                else:
                    sys.stdout.write('\x1b[1;37m' + 'Using remote dataset [%s <- %s] ' % (
                        base_path, remote_info['url']) + '\x1b[0m\n')

                if dataset == base_name:  # basename included
                    dataset_path = base_path
                    args.file.append(dataset_path)
                if dataset != base_name and base_name not in args.dataset:
                    subset_name = dataset.split('/')[1]
                    dataset_path = os.path.join(
                        base_path, remote_info['subsets'][subset_name])
                    args.file.append(dataset_path)
            else:
                dataset_path = cfg_dataset[dataset]
                args.file.append(dataset_path)

    for file in args.file:
        if os.path.isdir(file):
            for root, _, files in os.walk(file):
                for name in files:
                    file_path = os.path.join(root, name)
                    if conf.is_bytecode and not name.endswith(".hex"):
                        continue
                    if not conf.is_bytecode and not name.endswith(".sol"):
                        continue
                    if os.name == 'nt':
                        file_path = file_path.replace('\\', '/')
                    files_to_analyze.append(file_path)
        else:
            # file is a file
            if os.name == 'nt':
                file = file.replace('\\', '/')
            files_to_analyze.append(file)

    tasks = []
    for file in files_to_analyze:
        for tool in args.tool:
            task = Execution_Task(tool, file, conf)
            if conf.skip_existing:
                folder = os.path.join(task.result_output_path(), 'result.json')
                if os.path.exists(folder):
                    continue

            tasks.append(task)

    return tasks


if __name__ == '__main__':
    args = create_parser()

    if args.execution_name is not None:
        output_folder = args.execution_name
    else:
        output_folder = strftime("%Y%m%d_%H%M", localtime())

    conf = Execution_Configuration(
        execution_name=output_folder, output_folder="results", is_bytecode=args.bytecode, skip_existing=args.skip_existing, processes=args.processes, aggregate_sarif=args.aggregate_sarif, unique_sarif_output=args.unique_sarif_output, output_version=args.output_version)

    pathlib.Path(os.path.join(conf.output_folder, "logs")
                 ).mkdir(parents=True, exist_ok=True)
    logs.file_path = os.path.join(
        conf.output_folder, "logs", 'SmartBugs_' + output_folder + '.log')

    tasks = create_tasks(conf, args)
    execution = Execution(tasks=tasks)
    execution.exec()
