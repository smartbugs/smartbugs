
#!/usr/bin/env python3
import yaml
import logging
import argparse
import os
import sys

DATASET_CHOICES = ['all']
TOOLS_CHOICES = ['all']
CONFIG_TOOLS_PATH = os.path.abspath('config/tools')
CONFIG_DATASET_PATH= os.path.abspath('config/dataset/dataset.yaml')

with open(CONFIG_DATASET_PATH, 'r') as ymlfile:
    try:
        cfg_dataset = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        print(exc)


class InfoAction(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        for tool in values:
            cfg_path = os.path.abspath('config/tools/' + tool + '.yaml')
            with open(cfg_path , 'r') as ymlfile:
                try:
                    cfg = yaml.safe_load(ymlfile)
                except yaml.YAMLError as exc:
                    print(exc)
            if 'info' in cfg:
                print('\x1b[1;37m' +  tool  + '\x1b[0m' + ': ' + cfg['info'])
            else:
                print('\x1b[1;37m' +  tool + '\x1b[0m' + ': ' +'no info provided.')
        parser.exit()

class ListAction(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        for value in values:
            if value == 'tools':
                print('Here are the tools choices: ')
                for tool in TOOLS_CHOICES:
                    print(tool)
                sys.stdout.write('\n')
            elif value == 'datasets':
                print('Here are the vulnerabilities datasets choices:')
                for dataset in DATASET_CHOICES:
                    print(dataset + ' ')
                sys.stdout.write('\n')
        parser.exit()

#Parser stuff
def create_parser():
    parser = argparse.ArgumentParser(description="Static analysis of Ethereum smart contracts")
    group_source_files = parser.add_mutually_exclusive_group(required='True')
    group_tools = parser.add_mutually_exclusive_group(required='True')
    parser._optionals.title = "options:"


    parser.register('action', 'info', InfoAction)
    info = parser.add_argument_group('info')

    parser.register('action', 'list', ListAction)
    list = parser.add_argument_group('list')

    for name in cfg_dataset.items():
        DATASET_CHOICES.append(name[0])

    #get tools available by parsing the name of the config files
    tools = [os.path.splitext(f)[0] for f in os.listdir(CONFIG_TOOLS_PATH) if os.path.isfile(os.path.join(CONFIG_TOOLS_PATH, f))]
    for tool in tools:
        TOOLS_CHOICES.append(tool)

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
                        #required=True)

    list.add_argument('-l',
                        '--list',
                        choices=['tools', 'datasets'],
                        nargs='+',
                        action='list',
                        help='list tools or datasets')

    info.add_argument('-i',
                        '--info',
                        choices=TOOLS_CHOICES,
                        nargs='+',
                        action='info',
                        help='information about tool')
    
    info.add_argument('--skip-existing',
                        action='store_true',
                        help='skip the analsis that already have results')

    info.add_argument('--processes',
                        type=int,
                        default=1,
                        help='The number of parallel execution')

    args = parser.parse_args()
    return(args)
