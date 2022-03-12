import os, yaml

TOOLS_CFG_PATH = os.path.join(os.path.dirname(__file__), '..', 'config', 'tools')
TOOLS = {}
for f in os.listdir(TOOLS_CFG_PATH):
    tool_name,ext = os.path.splitext(f)
    tool_cfg = os.path.join(TOOLS_CFG_PATH, f)
    if os.path.isfile(tool_cfg) and ext == ".yaml":
        with open(tool_cfg, 'r', encoding='utf-8') as ymlfile:
            try:
                TOOLS[tool_name] = yaml.safe_load(ymlfile)
            except yaml.YAMLError as exc:
                print(exc)
TOOL_CHOICES = TOOLS.keys()

DATASETS_CFG_PATH = os.path.join(os.path.dirname(__file__), '..', 'config', 'datasets.yaml')
with open(DATASETS_CFG_PATH, 'r') as ymlfile:
    try:
        DATASETS = yaml.safe_load(ymlfile)
    except yaml.YAMLError as exc:
        print(exc)

DATASET_CHOICES = []
for name,location in DATASETS.items():
    if isinstance(location, dict) and 'subsets' in location:
        for sname in location['subsets']:
            DATASET_CHOICES.append(f"{name}/{sname}")
    else:
        DATASET_CHOICES.append(name)

def is_remote_info(info):
    return isinstance(info,dict) and 'url' in info and 'local_dir' in info

def get_remote_info(info):
    return (info['url'], info['local_dir'])

import pandas
VULNERABILITY_MAP_PATH = os.path.join(os.path.dirname(__file__), 'output_parser', 'sarif_vulnerability_mapping.csv')
VULNERABILITY_MAP = pandas.read_csv(VULNERABILITY_MAP_PATH)
