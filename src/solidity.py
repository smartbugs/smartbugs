import os,re
from pathlib import Path
from typing import Optional
import solcx.install as solc
# patch solcx to use Linux, independently of current OS
solc._get_os_name.__code__ = (lambda:"linux").__code__

VOID_START = re.compile('//|/\*|"|\'')
PRAGMA = re.compile('pragma solidity.*?;')
QUOTE_END = re.compile("(?<!\\\\)'")
DQUOTE_END = re.compile('(?<!\\\\)"')

def remove_void(line):
    while m := VOID_START.search(line):
        if m[0] == '//':
            return (line[:m.start()], False)
        if m[0] == '/*':
            end = line.find('*/', m.end())
            if end == -1:
                return (line[:m.start()], True)
            else:
                line = line[:m.start()] + line[end+2:]
                continue
        if m[0] == '"':
            m2 = DQUOTE_END.search(line[m.end():])
        else: # m[0] == "'":
            m2 = QUOTE_END.search(line[m.end():])
        if m2:
            line = line[:m.start()] + line[m.end()+m2.end():]
            continue
        # we should not arrive here for a correct Solidity program
        return (line[:m.start()], False)
    return (line, False)

def get_pragma(file: str) -> Optional[str]:
    in_comment = False
    for line in file.splitlines():
        if in_comment:
            end = line.find('*/')
            if end == -1:
                continue
            else:
                line = line[end+2:]
        line, in_comment = remove_void(line)
        if m := PRAGMA.search(line):
            pragma = m[0]
            return re.sub(r'(\D)0+(\d)',r'\1\2', pragma) # remove leading zeros
    return None

def get_solc(filename: str) -> Optional[Path]:
    with open(filename) as f:
        file = f.read()
    pragma = get_pragma(file)
    if not pragma:
        return None
    version = solc.install_solc_pragma(pragma)
    if not version:
        return None
    return solc.get_executable(version)
