import os,re
from pathlib import Path

import solcx
# load binaries for Linux in Docker images, not for host platform
solcx.set_target_os("linux")



VOID_START = re.compile("//|/\*|\"|'")
QUOTE_END = re.compile("(?<!\\\\)'")
DQUOTE_END = re.compile('(?<!\\\\)"')

def remove_comments_strings(prg):
    todo = "\n".join(prg) # normalize line ends
    done = ""
    while True:
        m = VOID_START.search(todo)
        if not m:
            done += todo
            break
        else:
            done += todo[:m.start()]
            if m[0] == "//":
                end = todo.find('\n', m.end())
                todo = "" if end == -1 else todo[end:]
            elif m[0] == "/*":
                end = todo.find("*/", m.end())
                done += " "
                todo = "" if end == -1 else todo[end+2:]
            else:
                if m[0] == "'":
                    m2 = QUOTE_END.search(todo[m.end():])
                else:
                    m2 = DQUOTE_END.search(todo[m.end():])
                if not m2:
                    # unclosed string
                    break
                todo = todo[m.end()+m2.end():]
    return done



PRAGMA = re.compile("pragma solidity.*?;")
RE_CONTRACT_NAMES = re.compile(r'(?:contract|library)\s+([A-Za-z0-9_]*)(?:\s*{|\s+is\s)')

def get_pragma_contractnames(prg):
    prg_wo_comments_strings = remove_comments_strings(prg)
    m = PRAGMA.search(prg_wo_comments_strings)
    pragma = m[0] if m else None
    contractnames = RE_CONTRACT_NAMES.findall(prg_wo_comments_strings)
    return pragma,contractnames



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
    # correct >=0.y.z to ^0.y.z
    pragma = re.sub(r">=0\.", r"^0.", pragma)
    # replace x.y by x.y.0
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
