import re
import sys
from typing import Any

from colorama import Fore, Style


ANSIcolor = re.compile("\x1b\\[[^m]*m")


def strip(s: Any) -> str:
    return ANSIcolor.sub("", str(s))


if sys.platform == "win32":

    def color(col: str, s: Any) -> str:
        return s

else:

    def color(col: str, s: Any) -> str:
        return f"{col}{s}{Style.RESET_ALL}"


def file(s: Any) -> str:
    return color(Fore.BLUE, s)


def tool(s: Any) -> str:
    return color(Fore.CYAN, s)


def error(s: Any) -> str:
    return color(Fore.RED, s)


def warning(s: Any) -> str:
    return color(Fore.YELLOW, s)


def success(s: Any) -> str:
    return color(Fore.GREEN, s)
