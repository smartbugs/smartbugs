import os,re
from pathlib import Path

import solcx
# load binaries for Linux in Docker images, not for host platform
solcx.set_target_os("linux")

# Cache list of available compilers once it has been loaded
version_list = None

# Cache mapping from versions to loaded compilers
solc = {}

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

def get_pragma(prg):
    in_comment = False
    for line in prg:
        if in_comment:
            end = line.find('*/')
            if end == -1:
                continue
            else:
                line = line[end+2:]
        line, in_comment = remove_void(line)
        if m := PRAGMA.search(line):
            return m[0]
    return None

def get_solc_version(prg):
    global version_list
    if not version_list:
        version_list = solcx.get_installable_solc_versions()
    pragma = get_pragma(prg)
    if not pragma:
        return None
    pragma = re.sub(r">=0\.", r"^0.", pragma)
    version = solcx.install._select_pragma_version(pragma, version_list)
    return version

def get_solc_path(version):
    if not version:
        return None
    if version not in solc:
        try:
            solc[version] = solcx.get_executable(version)
        except:
            solc[version] = None
    return solc[version]

