import colorama, re, sys
from colorama import Fore, Style

ANSIcolor = re.compile('\x1b\[[^m]*m')
def strip(s):
    return ANSIcolor.sub('',str(s))

if sys.platform == "win32":
    def color(col, s):
        return s
else:
    def color(col, s):
        return f"{col}{s}{Style.RESET_ALL}"

def file(s):
    return color(Fore.BLUE, s)

def tool(s):
    return color(Fore.CYAN, s)

def error(s):
    return color(Fore.RED, s)

def warning(s):
    return color(Fore.YELLOW, s)

def success(s):
    return color(Fore.GREEN, s)

