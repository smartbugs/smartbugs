#!/usr/bin/env python3
import yaml
import argparse
import os
import sys
from time import localtime, strftime
from src.execution.execution_configuration import Execution_Configuration
from src.utils import COLSTATUS,COLRESET
from src.logger import logs
from src.tools import TOOLS

CONFIG_DATASET_PATH = os.path.join(os.path.dirname(__file__), '..', '..', 'config', 'dataset', 'dataset.yaml')
DATASET_CHOICES = ['all']
with open(CONFIG_DATASET_PATH, 'r') as ymlfile:
    try:
        cfg_dataset = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        logs.print(exc)
for name,location in cfg_dataset.items():
    if isinstance(location, dict) and 'subsets' in location:
        for sname in location['subsets']:
            DATASET_CHOICES.append(f"{name}/{sname}")
    else:
        DATASET_CHOICES.append(name)

TOOLS_CHOICES = ['all']
TOOLS_CHOICES += TOOLS.keys()

def is_remote_info(info):
    return isinstance(info,dict) and 'url' in info and 'local_dir' in info

def get_remote_info(info):
    return (info['url'], info['local_dir'])

class InfoAction(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        for value in values:
            cfg = TOOLS[value]
            info = cfg['info'] if 'info' in cfg else 'no info available'
            print(f"{COLSTATUS}: {info}{COLRESET}")
        parser.exit()

class ListAction(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        for value in values:
            if value == 'tools':
                print('Choices for the analysis tool (option -t): ')
                print(' '.join(TOOLS_CHOICES))
            elif value == 'datasets':
                print('Choices for the vulnerability dataset to analyze (option --dataset):')
                print(' '.join(DATASET_CHOICES))
        parser.exit()

def get_config():
    parser = argparse.ArgumentParser(description="Static analysis of Ethereum smart contracts")
    group_source_files = parser.add_mutually_exclusive_group(required='True')
    group_tools = parser.add_mutually_exclusive_group(required='True')
    parser._optionals.title = "options:"

    parser.register('action', 'info', InfoAction)
    info = parser.add_argument_group('info')

    parser.register('action', 'list_option', ListAction)
    list_option = parser.add_argument_group('list_option')

    group_source_files.add_argument('-f',
                        '--file',
                        nargs='*',
                        default=[],
                        help='select solidity file(s) or directories to be analysed')

    group_source_files.add_argument('--dataset',
                        choices=DATASET_CHOICES,
                        help='pre made datasets',
                        nargs='+')

    group_tools.add_argument('-t',
                        '--tool',
                        choices=TOOLS_CHOICES,
                        nargs='+',
                        help='select tool(s)')

    list_option.add_argument('-l',
                        '--list',
                        choices=['tools', 'datasets'],
                        nargs='+',
                        action='list_option',
                        help='list tools or datasets')

    info.add_argument('-i',
                        '--info',
                        choices=TOOLS_CHOICES,
                        nargs='+',
                        action='info',
                        help='information about tool')

    info.add_argument('--bytecode',
                        action='store_true',
                        help='analyze bytecode')

    info.add_argument('--skip-existing',
                        action='store_true',
                        help='skip the analysis that already have results')

    info.add_argument('--processes',
                        type=int,
                        default=1,
                        help='The number of parallel execution')
    
    info.add_argument('--timeout',
                        type=int,
                        default=30*60,
                        help='The execution timeout of each process in sec')

    info.add_argument('--cpu-quota',
                        type=int,
                        default=150000,
                        help='The cpu quota provided to the docker image')

    info.add_argument('--mem-quota',
                        type=str,
                        default=None,
                        help='The memory quota provided to the docker image (e.g. 512m or 1g)')
    
    info.add_argument('--execution-name',
                        help='Define the name of the execution')

    info.add_argument('--import-path',
                        type=str,
                        default="FILE",     # different directory solidity imports will not work
                        help="Project's root directory")

    info.add_argument('--sarif-output',
                        action='store_true',
                        help='Generate SARIF output')

    info.add_argument('--aggregate-sarif',
                        action='store_true',
                        help='Aggregate sarif outputs for different tools run on the same file')

    info.add_argument('--unique-sarif-output',
                      action='store_true',
                      help='Aggregates all sarif analysis outputs in a single file')

    args = parser.parse_args()


    if args.execution_name is not None:
        output_folder = args.execution_name
    else:
        output_folder = strftime("%Y%m%d_%H%M", localtime())

    if args.unique_sarif_output or args.aggregate_sarif:
        # if we are aggregating sarif files, we need to generate the sarif output
        args.sarif_output = True
 
    conf = Execution_Configuration(
        execution_name=output_folder, 
        output_folder="results", 
        is_bytecode=args.bytecode, 
        skip_existing=args.skip_existing, 
        processes=args.processes, 
        aggregate_sarif=args.aggregate_sarif, 
        unique_sarif_output=args.unique_sarif_output, 
        sarif_output=args.sarif_output,
        timeout=args.timeout,
        cpu_quota=args.cpu_quota,
        mem_quota=args.mem_quota,
        tools=args.tool,
        files=args.file,
        datasets=args.dataset)
        
    return conf
