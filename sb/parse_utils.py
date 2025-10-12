"""Utilities for the output parsers"""

import re
from collections.abc import Generator, Iterable
from re import Pattern
from typing import Optional


DOCKER_CODES: dict[int, str] = {
    125: "DOCKER_INVOCATION_PROBLEM",
    126: "DOCKER_CMD_NOT_EXECUTABLE",
    127: "DOCKER_CMD_NOT_FOUND",
    137: "DOCKER_KILL_OOM",  # container received KILL signal, manually or because out of memory
    139: "DOCKER_SEGV",  # segmentation violation
    143: "DOCKER_TERM",  # container was externally stopped
}


ANSI: Pattern[str] = re.compile("\x1b\\[[^m]*m")


def discard_ansi(lines: Iterable[str]) -> Generator[str, None, None]:
    return (ANSI.sub("", line) for line in lines)


def truncate_message(m: str, length: int = 205) -> str:
    half_length = (length - 5) // 2
    return m if len(m) <= length else m[:half_length] + " ... " + m[-half_length:]


TRACEBACK: str = "Traceback (most recent call last):"  # Python

EXCEPTIONS: tuple[Pattern[str], ...] = (
    re.compile(".*line [0-9: ]*(Segmentation fault|Killed)"),  # Shell
    re.compile('Exception in thread "[^"]*" (.*)'),  # Java
    re.compile(r"^(?:[a-zA-Z0-9]+\.)+[a-zA-Z0-9]*Exception: (.*)$"),  # Java
    re.compile("thread '[^']*' panicked at '([^']*)'"),  # Rust
)


def exceptions(lines: list[str]) -> set[str]:
    exceptions = set()
    traceback = False
    for line in lines:
        if traceback:
            if line and line[0] != " ":
                exceptions.add(f"exception ({line})")
                traceback = False
        elif line.endswith(TRACEBACK):
            traceback = True
        else:
            for re_exception in EXCEPTIONS:
                if m := re_exception.match(line):
                    exceptions.add(f"exception ({m[1]})")
    return exceptions


def add_match(matches: set[str], line: str, patterns: list[Pattern[str]]) -> bool:
    for pattern in patterns:
        m = pattern.match(line)
        if m:
            matches.add(m[1])
            return True
    return False


def errors_fails(
    exit_code: Optional[int], log: Optional[list[str]], log_expected: bool = True
) -> tuple[set[str], set[str]]:
    errors = set()  # errors detected and handled by the tool
    fails = set()  # exceptions not caught by the tool, or outside events leading to abortion
    if exit_code is None:
        fails.add("DOCKER_TIMEOUT")
    elif exit_code == 0:
        pass
    elif exit_code == 127:
        fails.add(
            "SmartBugs was invoked with option 'main', but the filename did not match any contract"
        )
    elif exit_code in DOCKER_CODES:
        fails.add(DOCKER_CODES[exit_code])
    elif 128 <= exit_code <= 128 + 64:
        fails.add(f"DOCKER_RECEIVED_SIGNAL_{exit_code-128}")
    else:
        # remove it for individual signals and tools, where it is not an error
        errors.add(f"EXIT_CODE_{exit_code}")
    if log:
        fails.update(exceptions(log))
    elif log_expected and not fails:
        fails.add("execution failed")
    return errors, fails
