'''To be used by the output parsers'''

import re

DOCKER_CODES = {
    125: "DOCKER_INVOCATION_PROBLEM",
    126: "DOCKER_CMD_NOT_EXECUTABLE",
    127: "DOCKER_CMD_NOT_FOUND",
    137: "DOCKER_KILL_OOM", # container received KILL signal, manually or because out of memory
    139: "DOCKER_SEGV", # segmentation violation
    143: "DOCKER_TERM" # container was externally stopped
}


ANSI = re.compile('\x1b\[[^m]*m')
def discard_ANSI(lines):
    return [ ANSI.sub('',line) for line in lines ]


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
                m = re_exception.match(line)
                if m:
                    exceptions.add(f"exception ({m[1]})")
    return exceptions


def add_match(matches, line, patterns):
    for pattern in patterns:
        m = pattern.match(line)
        if m:
            matches.add(m[1])
            return True
    return False


def init(exit_code, log, log_expected=True, skip=lambda line: False):
    findings = set() # properties of the contract as determined by the tool
    infos    = set() # notifications by the tool
    errors   = set() # errors detected and handled by the tool
    fails    = set() # exceptions not caught by the tool, or outside events leading to abortion
    analysis = []
    if exit_code is None:
        fails.add('DOCKER_TIMEOUT')
    elif exit_code in (0,-10): # -10 means that the exit code was not recorded
        pass
    elif exit_code in DOCKER_CODES:
        fails.add(DOCKER_CODES[exit_code])
    elif 128 <= exit_code <= 128+64:
        fails.add(f"DOCKER_RECEIVED_SIGNAL_{exit_code-128}")
    else:
        # remove it for individual signals and tools, where it is not an error
        errors.add(f"EXIT_CODE_{exit_code}")
    if log:
        fails.update(exceptions(log, skip))
    elif log_expected and not fails:
        fails.add('execution failed')
    return findings, infos, errors, fails, analysis

