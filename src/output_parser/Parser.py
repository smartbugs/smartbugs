import re, json, importlib
from typing import List
import src.execution.execution_configuration as execution_configuration
import src.execution.execution_task as execution_task
import os



class Parser:
    """Base class of all output parsers."""

    def __init__(self, task: 'execution_task.Execution_Task', output: str):
        self._task     = task
        self._lines    = [] if output is None else sanitized(output.splitlines())
        self._findings = set()
        self._errors   = set()
        self._analysis = None

    def findings(self) -> List[str]:
        return sorted([str2label(f) for f in self._findings])

    def errors(self) -> List[str]:
        # Run is considered successful if self.errors() == set(), and unsuccessful otherwise
        # Make sure to add an error if the output is missing or incomplete
        return sorted(self._errors)

    def analysis(self):
        return self._analysis

    def result(self):
        return {
            "findings": self.findings(),
            "errors": self.errors(),
            "analysis": self.analysis()
            }

    def parseSarif(self, str, file_path_in_repo):
        pass



######################################################
# Utility functions

RUBBISH = (
    'ANTLR runtime and generated code versions disagree: ',
    'DeprecationWarning: Python 2 support is ending!'
    )
ANSI = re.compile('\x1b\[[^m]*m')

def is_rubbish(line):
    for r in RUBBISH:
        if r in line:
            return True
    return False

def sanitized(lines):
    """Remove rubbish and ANSI color escapes."""
    slines = []
    for line in lines:
        if not is_rubbish(line):
            slines.append(ANSI.sub('',line))
    return slines


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


EXCEPTIONS = (
    ("Traceback (most recent call last):", re.compile(f"(?s:Traceback \(most recent call last\).*?)\n(?=\S)(.*)")), # Python
    ("Exception in thread", re.compile(f'Exception in thread "[^"]*" (.*)')) # Java
    )

def exceptions(output):
    """Detect uncaught exceptions in output."""
    exceptions = set()
    for indicator, re_exception in EXCEPTIONS:
        if indicator in output:
            es = re_exception.findall(output)
            if es:
                exceptions.update({f"exception ({e})" for e in es})
            else:
                exceptions.add("exception")
    return exceptions



################################################
# Running parser standalone

# The string below has to match the one in src/execution/execution.py
# Currently, an explicit import is cumbersome (circularity). Dependency
# will vanish with Smartbugs 2.0, where run information will be
# separated from parser output
DOCKER_TIMEOUT = 'Docker container timed out'

def reparse(output_parser, log_name, json_name):
    """Parse the output of a tool for a single contract.

    Runs output_parser on log_name (typically .../result.log) and any other
    output files in the same directory. If json_name exists (typically .../result.json),
    it is used to initialize the dict with the parsed results, in order to keep run times.
    """

    # read result.log (stdout of tool)
    try:
        with open(log_name) as f:
            result_log = f.read().rstrip()
    except:
        result_log = None

    # read result.json (old parser output)
    try:
        with open(json_name) as f:
            result_json = json.load(f)
    except:
        result_json = {}

    # did a docker timeout occur when originally running the tool?
    timeout = (('errors' in result_json and DOCKER_TIMEOUT in result_json['errors']) or
               ('exit_code' in result_json and result_json['exit_code'] is None))

    # dummy config
    path,_ = os.path.split(os.path.abspath(log_name))
    path,file_name = os.path.split(path)
    path,execution_name = os.path.split(path)
    output_folder,tool = os.path.split(path)
    exec_cfg = execution_configuration.Execution_Configuration(
        output_folder, execution_name,
        None, None, None, None, None, None, None, None, None, None, None, None)
    exec_task = execution_task.Execution_Task(tool, file_name, exec_cfg)

    # reparse
    if type(output_parser) == str:
        module = importlib.import_module(f"src.output_parser.{output_parser}")
        output_parser = getattr(module, output_parser)

    p = output_parser(exec_task, result_log)

    # write new result.json (new parser output)
    for k,v in p.result().items():
        result_json[k] = v
    if timeout and DOCKER_TIMEOUT not in result_json['errors']:
        result_json['errors'].append(DOCKER_TIMEOUT)
    result_json['success'] = result_json['errors'] == []
    return result_json
