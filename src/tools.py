import os, yaml
from src.logger import logs

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
                logs.print(exc)
