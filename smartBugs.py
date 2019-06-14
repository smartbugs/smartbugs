#!/usr/bin/env python3

import docker
import yaml
import logging
import argparse
import os
import sys
from time import time, gmtime, strftime
from src.interface.cli import create_parser, DATASET_CHOICES, TOOLS_CHOICES
from src.docker_api.docker_api import analyse_files

cfg_dataset_path = os.path.abspath('config/dataset/dataset.yaml')
with open(cfg_dataset_path , 'r') as ymlfile:
    try:
        cfg_dataset = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        print(exc)


def exec_cmd(args: argparse.Namespace):

    now = strftime("%Y%d%m_%H%M", gmtime())
    logs = open('results/logs/SmartBugs_'+ now +'.log', 'w')
    logs.write('Arguments passed: ' + str(sys.argv) + '\n')

    if args.tool == ['all']:
        TOOLS_CHOICES.remove('all')
        args.tool = TOOLS_CHOICES

    for tool in args.tool:

        if args.file:
            for file in args.file:
                #check if dirs or file exists
                if not os.path.exists(file):
                    sys.exit(file + ': path does not exist.')

                #analyse files
                if os.path.basename(file).endswith('.sol'):
                    analyse_files(tool, file, logs, now)

                #analyse dirs recursively
                elif os.path.isdir(file):
                    for root, dirs, files in os.walk(file):
                        for name in files:
                            if name.endswith('.sol'):
                                analyse_files(tool, os.path.join(root, name), logs, now)
                else:
                    print('you should provide a directory or a solidity file path')

        elif args.dataset:

            if args.dataset == ['all']:
                DATASET_CHOICES.remove('all')
                args.dataset = DATASET_CHOICES

            for dataset in args.dataset:
                dataset_path = cfg_dataset[dataset]
                if isinstance(dataset_path, list):
                    for name_path in dataset_path:
                        #check if dirs or file exists
                        if not os.path.exists(name_path):
                            sys.exit(name_path + ': path does not exist.')

                        #analyse files
                        elif os.path.basename(name_path).endswith('.sol'):
                            analyse_files(tool, name_path, logs, now)

                        #analyse dirs
                        elif os.path.isdir(name_path):
                            for name in os.listdir(name_path):
                                if name.endswith('.sol'):
                                    analyse_files(tool, os.path.join(name_path, name), logs, now)
                else:
                    #check if dirs or file exists
                    if not os.path.exists(dataset_path):
                        sys.exit(dataset_path + ': path does not exist.')

                    #analyse files
                    elif os.path.basename(dataset_path).endswith('.sol'):
                        analyse_files(tool, dataset_path, logs, now)

                    #analyse dirs
                    elif os.path.isdir(dataset_path):
                        for name in os.listdir(dataset_path):
                            if name.endswith('.sol'):
                                analyse_files(tool, os.path.join(dataset_path, name), logs, now)
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