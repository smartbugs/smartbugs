import re, json, importlib
from typing import List, Optional
import src.execution.execution_configuration as execution_configuration
import src.execution.execution_task as execution_task
import os

DOCKER_CODES = {
    125: "DOCKER_INVOCATION_PROBLEM",
    126: "DOCKER_CMD_NOT_EXECUTABLE",
    127: "DOCKER_CMD_NOT_FOUND",
    137: "DOCKER_KILL_OOM", # container received KILL signal, manually or because out of memory
    139: "DOCKER_SEGV", # segmentation violation
    143: "DOCKER_TERM" # container was externally stopped
}

class Parser:
    """Base class of all output parsers."""

    def __init__(self, task: 'execution_task.Execution_Task', output: str, output_expected=True, skip = lambda line: False):
        self._task     = task
        self._lines    = [] if not output else output.splitlines()
        self._findings = set() # properties of the contract as determined by the tool
        self._messages = set() # notifications by the tool
        self._errors   = set() # errors detected and handled by the tool
        self._fails    = set() # exceptions not caught by the tool, or outside events leading to abortion
        self._analysis = []
        if task.exit_code is None:
            self._fails.add('DOCKER_TIMEOUT')
        elif task.exit_code in (0,-10): # -10 means that the exit code was not recorded
            pass
        elif task.exit_code in DOCKER_CODES:
            self._fails.add(DOCKER_CODES[task.exit_code])
        elif 128 <= task.exit_code <= 128+64:
            self._fails.add(f"DOCKER_RECEIVED_SIGNAL_{task.exit_code-128}")
        else:
            # remove it for individual signals and tools, where it is not an error
            self._errors.add(f"EXIT_CODE_{task.exit_code}")
        if self._lines:
            self._fails.update(exceptions(self._lines, skip))
        elif output_expected and not self._fails:
            self._fails.add('execution failed')

    @classmethod
    def portfolio(cls) -> List[str]:
        '''Return the list of findings that the tool potentially detects.'''
        return sorted([str2label(f) for f in cls.PORTFOLIO])

    def findings(self) -> List[str]:
        return sorted([str2label(f) for f in self._findings])

    def messages(self) -> List[str]:
        return sorted(self._messages)

    def errors(self) -> List[str]:
        return sorted(self._errors)

    def fails(self) -> List[str]:
        return sorted(self._fails)

    def analysis(self):
        return self._analysis

    def result(self):
        return {
            "findings": self.findings(),
            "messages": self.messages(),
            "errors": self.errors(),
            "fails": self.fails(),
            "analysis": self.analysis(),
            "parser": {
                "name": self.NAME,
                "version": self.VERSION,
            }
        }

    def parseSarif(self, str, file_path_in_repo):
        pass



######################################################
# Utility functions

ANSI = re.compile('\x1b\[[^m]*m')
def discard_ANSI(lines):
    return [ ANSI.sub('',line) for line in lines ]

def str2label(s):
    """Convert string to label.

    The label is constructed as follows:
    - letters and digits remain unaffected
    - other leading or trailing characters are removed
    - sequences of other characters occurring inbetween are replaced by a single underscore
    """
    l = []
    sep = False
    ch = False
    for c in s: # or "in s.lower()" (convert to lowercase)?
        if c.isalnum(): # "or c in '-'", to allow for - and maybe other characters?
            if sep:
                l.append('_')
                sep = False
            l.append(c)
            ch = True
        else:
            sep = ch
    return ''.join(l)

def truncate_message(m, length=205):
    half_length = (length-5)//2
    return m if len(m) <= length else m[:half_length]+' ... '+m[-half_length:]


TRACEBACK = "Traceback (most recent call last)" # Python

EXCEPTIONS = (
    re.compile(".*line [0-9: ]*(Segmentation fault|Killed)"), # Shell
    re.compile('Exception in thread "[^"]*" (.*)'), # Java
    re.compile("thread '[^']*' panicked at '([^']*)'"), # Rust
)

def exceptions(lines, skip):
    exceptions = set()
    traceback = False
    for line in lines:
        if skip(line):
            continue 
        if traceback:
            if line and line[0] != " ":
                exceptions.add(f"exception ({line})")
                traceback = False
        elif line.startswith(TRACEBACK):
            traceback = True
        else:
            for re_exception in EXCEPTIONS:
                if m := re_exception.match(line):
                    exceptions.add(f"exception ({m[1]})")
    return exceptions


def add_match(matches, line, patterns):
    for pattern in patterns:
        if m := pattern.match(line):
            matches.add(m[1])
            return True
    return False


################################################
# Running parser standalone

def reparse(log, jsn=None, parser=None):
    """Parse the output of a tool for a single contract.

    Runs parser on log (typically .../result.log) and any other
    output files in the same directory. If jsn exists (typically .../result.json),
    it is used to initialize the dict with the parsed results, to keep run times.
    """

    path,_ = os.path.split(os.path.abspath(log))
    if not jsn:
        jsn = os.path.join(path,"result.json")
    path,file_name = os.path.split(path)
    path,execution_name = os.path.split(path)
    output_folder,tool = os.path.split(path)

    # read result.log (stdout of tool)
    try:
        with open(log) as f:
            result_log = f.read().rstrip()
    except:
        result_log = None

    # read result.json (old parser output)
    try:
        with open(jsn) as f:
            result_json = json.load(f)
        if 'success' in result_json:
            del result_json['success']
    except:
        result_json = {
            "duration": None
        }
    if "exit_code" not in result_json:
        result_json["exit_code"] = -10 # old smartbugs output

    # dummy config
    exec_cfg = execution_configuration.Execution_Configuration(
        output_folder, execution_name,
        None, None, None, None, None, None, None, None, None, None, None, None)
    exec_task = execution_task.Execution_Task(tool, file_name+".XXX", exec_cfg)
    exec_task.exit_code = result_json["exit_code"]

    if not parser:
        if tool in result_json:
            tool = result_json["tool"]
        if   tool == "ethor":       parser = "EThor"
        elif tool == "honeybadger": parser = "HoneyBadger"
        elif tool == "madmax":      parser = "MadMax"
        elif tool == "teether":     parser = "TeEther"
        else:                       parser = tool.capitalize()

    # reparse
    if type(parser) == str:
        module = importlib.import_module(f"src.output_parser.{parser}")
        parser = getattr(module, parser)
    p = parser(exec_task, result_log)
    for k,v in p.result().items():
        result_json[k] = v
    if 'contract' not in result_json:
        result_json['contract'] = file_name
    if 'tool' not in result_json:
        result_json['tool'] = tool
    return result_json
