import sys, os, yaml, pathlib, csv
import src.logging as log
import src.colors as col

BASE_DIR = pathlib.Path(__file__).resolve().parent.parent



TOOLS_CFG_PATH = os.path.join(BASE_DIR, 'config', 'tools')
TOOLS = {}
for f in os.listdir(TOOLS_CFG_PATH):
    tool_name,ext = os.path.splitext(f)
    tool_cfg = os.path.join(TOOLS_CFG_PATH, f)
    if os.path.isfile(tool_cfg) and ext == ".yaml":
        with open(tool_cfg, 'r', encoding='utf-8') as ymlfile:
            try:
                TOOLS[tool_name] = yaml.safe_load(ymlfile)
                TOOLS[tool_name]["name"] = tool_name
            except yaml.YAMLError as err:
                log.message(f"{col.error('Error reading tool configuration file')} {col.error(tool_cfg)}\n{err}")
                sys.exit(1)
TOOL_CHOICES = TOOLS.keys()



DATASETS_CFG_PATH = os.path.join(BASE_DIR, 'config', 'datasets.yaml')
DATASETS_PARENT = BASE_DIR
with open(DATASETS_CFG_PATH, 'r') as ymlfile:
    try:
        DATASETS = yaml.safe_load(ymlfile)
    except yaml.YAMLError as err:
        log.message(f"{col.error('Error reading dataset configuration file')} {col.error(DATASETS_CFG_PATH)}\n{err}")
        sys.exit(1)

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
    return (info['url'], info['local_dir'], info['subsets'])



VULNERABILITY_MAP_PATH = os.path.join(BASE_DIR, 'src', 'output_parser', 'sarif_vulnerability_mapping.csv')
VULNERABILITY_MAP = {}
with open(VULNERABILITY_MAP_PATH, 'r') as csvfile:
    rows = csv.reader(csvfile)
    next(rows)
    for Tool,RuleId,Vulnerability,Type in rows:
        if Tool not in VULNERABILITY_MAP:
            VULNERABILITY_MAP[Tool] = []
        VULNERABILITY_MAP[Tool].append((RuleId,Vulnerability,Type))
