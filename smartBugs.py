#!/usr/bin/env python3

import argparse
import git
import os
import pathlib
import sys
import yaml
from typing import List

from src.execution.execution import Execution
from src.execution.execution_task import Execution_Task
from src.execution.execution_configuration import Execution_Configuration
from src.logger import logs
from src.interface.cli import get_config, cfg_dataset, is_remote_info, get_remote_info
from src.utils import COLSTATUS,COLRESET,COLERR
from src.execution.docker_api import tool_conf, tool_image, pull_image

def create_tasks(conf: 'Execution_Configuration') -> List['Execution_Task']:
    files_to_analyze = []

    if conf.datasets:
        for dataset in conf.datasets:
            base_name = dataset.split('/')[0]
            dataset_info = cfg_dataset[base_name]
            if is_remote_info(dataset_info):
                (url, base_path) = get_remote_info(dataset_info)

                if not os.path.isdir(base_path):
                    # local copy does not exist; we need to clone it
                    sys.stdout.write(f"{COLSTATUS}{base_name} is a remote dataset. Do you want to create a local copy? [Y/n]{COLRESET} ")
                    sys.stdout.flush()
                    answer = input()
                    if answer.lower() in ['yes', 'y', '']:
                        sys.stdout.write(f"{COLSTATUS}Cloning remote dataset [{base_path} <- {url}]... {COLRESET}")
                        sys.stdout.flush()
                        git.Repo.clone_from(url, base_path)
                        sys.stdout.write(f"{COLSTATUS}Done.{COLRESET}")
                    else:
                        logs.print(f"{COLERR}ABORTING: cannot proceed without local copy of remote dataset {base_name}{COLRESET}")
                        quit()
                else:
                    sys.stdout.write(f"{COLSTATUS}Using remote dataset [{base_path} <- {url}]{COLRESET}\n")

                if dataset == base_name:  # basename included
                    dataset_path = base_path
                    conf.files.append(dataset_path)
                if dataset != base_name and base_name not in conf.datasets:
                    subset_name = dataset.split('/')[1]
                    dataset_path = os.path.join(
                        base_path, dataset_info['subsets'][subset_name])
                    conf.files.append(dataset_path)
            else:
                conf.files.append(dataset_info)

    for file in conf.files:
        if os.path.isdir(file):
            for root, _, files in os.walk(file):
                for name in files:
                    file_path = os.path.join(root, name)
                    if conf.is_bytecode and not name.endswith(".hex"):
                        logs.print(f"[WARNING] {file_path} is ignored (only .hex files are considered)")
                        continue
                    if not conf.is_bytecode and not name.endswith(".sol"):
                        logs.print(f"[WARNING] {file_path} is ignored (only .sol files are considered)")
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
        for tool in conf.tools:
            task = Execution_Task(tool, file, conf)
            if conf.skip_existing:
                folder = os.path.join(task.result_output_path(), 'result.json')
                if os.path.exists(folder):
                    continue

            tasks.append(task)

    return tasks


if __name__ == '__main__':
    conf = get_config()

    pathlib.Path(os.path.join(conf.output_folder, "logs")
                 ).mkdir(parents=True, exist_ok=True)
    logs.file_path = os.path.join(
        conf.output_folder, "logs", 'SmartBugs_' + conf.execution_name + '.log')
    logs.print(f"Settings: {conf.arguments_passed}")

    tasks = create_tasks(conf)

    if tasks:
        for tool in conf.tools:
            cfg = tool_conf(tool)
            image_soc5 = tool_image(cfg, solc_version=5, is_bytecode=conf.is_bytecode)
            pull_image(image_soc5)

            image_soc4 = tool_image(cfg, solc_version=4, is_bytecode=conf.is_bytecode)
            if image_soc4 != image_soc5:
                pull_image(image_soc4)

        execution = Execution(tasks=tasks)
        execution.exec()
