import sys, importlib.util
from sb.exceptions import SmartBugsError

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


toolparsers = {}

def get_parser(tid, tmode, fn):
    key = (tid,tmode)
    if key not in toolparsers:
        try:
            modulename = "tools.{tid}.{tmode}"
            spec = importlib.util.spec_from_file_location(modulename, fn)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            toolparsers[key] = module
        except BaseException as e:
            raise SmartBugsError(f"Cannot load parser for {tid}/{tmode} from {fn}\n{e}")
    return toolparsers[key]


def parse(exit_code, log, output, info):
    tool = info["tool"]
    tid, tmode, tparser = tool["id"], tool["mode"], tool["parser"]
    toolparser = get_parser(tid, tmode, tparser)
    try:
        findings, infos, errors, fails, analysis = toolparser.parse(exit_code, log, output, info)
    except BaseException as e:
        raise SmartBugsError(f"Parsing the result of analysis failed\n{e}")

    return {
        "findings": [str2label(f) for f in findings],
        "infos": list(infos),
        "errors": list(errors),
        "fails": list(fails),
        "analysis": analysis,
        "parser": {
            "id": tid,
            "mode": tmode,
            "version": toolparser.VERSION
            }
        }

