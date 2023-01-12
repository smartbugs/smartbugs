import os,re
from pathlib import Path

import solcx
# load binaries for Linux in Docker images, not for host platform
solcx.set_target_os("linux")


VOID_START = re.compile('//|/\*|"|\'')
PRAGMA = re.compile('pragma solidity.*?;')
QUOTE_END = re.compile("(?<!\\\\)'")
DQUOTE_END = re.compile('(?<!\\\\)"')

def remove_void(line):
    while True:
        m = VOID_START.search(line)
        if not m:
            break
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
        m = PRAGMA.search(line)
        if m:
            return m[0]
    return None


cached_solc_versions = None
def ensure_solc_versions_loaded():
    global cached_solc_versions
    if cached_solc_versions:
        return True
    try:
        cached_solc_versions = solcx.get_installable_solc_versions()
        return True
    except Exception:
        cached_solc_versions = solcx.get_installed_solc_versions()
        return False

def get_solc_version(pragma):
    if not pragma:
        return None
    pragma = re.sub(r">=0\.", r"^0.", pragma)
    pragma = re.sub(r"([^0-9])([0-9]+\.[0-9]+)([^0-9.]|$)", r"\1\2.0\3", pragma)
    try:
        version = solcx.install._select_pragma_version(pragma, cached_solc_versions)
    except Exception:
        version = None
    return version

cached_solc_paths = {}
def get_solc_path(version):
    if not version:
        return None
    if version in cached_solc_paths:
        return cached_solc_paths[version]
    try:
        solcx.install_solc(version)
        solc_path = solcx.get_executable(version)
    except Exception:
        solc_path = None
    cached_solc_paths[version] = solc_path
    return solc_path
