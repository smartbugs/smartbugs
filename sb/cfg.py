import os
from pathlib import Path
import platform
import cpuinfo

SB_VERSION = "2.1.0"

HOME = Path.home()
SB_LOCAL = HOME / ".smartbugs"
USER_CFG = SB_LOCAL / "cfg.yaml"
SOLC = SB_LOCAL / "solc"
TOOLS_LOCAL = SB_LOCAL / "tools"

SB_HOME = Path(__file__).parent.parent
SITE_CFG = SB_HOME / "site_cfg.yaml"
TOOLS_HOME = SB_HOME / "tools"

TASK_LOG = "smartbugs.json"
TOOL_CONFIG = "config.yaml"
TOOL_FINDINGS = "findings.yaml"
TOOL_PARSER = "parser.py"
TOOL_LOG = "result.log"
TOOL_OUTPUT = "result.tar"
PARSER_OUTPUT = "result.json"
SARIF_OUTPUT = "result.sarif"

CPU = cpuinfo.get_cpu_info()
UNAME = platform.uname()
PLATFORM = {
    "smartbugs": SB_VERSION,
    "python": CPU.get("python_version"),
    "system": UNAME.system,
    "release": UNAME.release,
    "version": UNAME.version,
    "machine": UNAME.machine,
    "host": hash(UNAME.node),  # pseudonymised
    "user": hash(os.environ.get("USER", os.environ.get("USERNAME"))),  # pseudonymised
    "cpu": CPU.get("brand_raw"),
}
