from solidity_parser import parser
from src.logger import logs
from typing import Dict

BLACK = '\x1b[1;30m'
RED = '\x1b[1;31m'
GREEN = '\x1b[1;32m'
YELLOW = '\x1b[1;33m'
BLUE = '\x1b[1;34m'
MAGENTA = '\x1b[1;35m'
CYAN = '\x1b[1;36m'
WHITE = '\x1b[1;37m'
COLRESET = '\x1b[0m'
COLSUCCESS = GREEN
COLERR = RED
COLWARN = YELLOW
COLINFO = BLUE
COLSTATUS = WHITE

def get_solc_version(file: str):
    """
    get solidity compiler version
    """
    try:
        with open(file, 'r', encoding='utf-8') as fd:
            sourceUnit = parser.parse(fd.read())
        solc_version = sourceUnit['children'][0]['value'].strip('^').split('.')
        if solc_version[0] == '0':
            return int(solc_version[1])
    except:
        msg = 'WARNING: could not parse solidity file to get solc version'
        logs.print(f"{COLWARN}{msg}{COLRESET}", msg)
    return None
