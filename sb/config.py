import os, time

VERSION = "2.0.0-pre1"
HOME = os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir))
TOOLS_HOME = os.path.join(HOME,"tools")
SITE_CFG = os.path.join(HOME,"site_cfg.yaml")
TASK_LOG = "smartbugs.json"
TOOL_LOG    = "result.log"
TOOL_OUTPUT = "result.tar"
