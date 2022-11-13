import sys, os, importlib.util
from sb.exceptions import SmartBugsError
import sb.config

tool_parsers = {}

def get_parser(tid, tmode, fn):
    key = (tid,tmode)
    if key not in tool_parsers:
        try:
            modulename = f"tools.{tid}.{tmode}"
            spec = importlib.util.spec_from_file_location(modulename, fn)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            tool_parsers[key] = module
        except Exception as e:
            raise SmartBugsError(f"Cannot load parser for {tid}/{tmode}\n{e}")
    return tool_parsers[key]


def parse(exit_code, log, output, info):
    tool = info["tool"]
    tool_id, tool_mode = tool["id"], tool["mode"]
    fn_parser = os.path.join(sb.config.TOOLS_HOME,tool_id,tool["parser"])
    tool_parser = get_parser(tool_id, tool_mode, fn_parser)

    try:
        findings,infos,errors,fails = tool_parser.parse(exit_code, log, output)
    except Exception as e:
        raise SmartBugsError(f"Parsing the result of analysis failed\n{e}")

    for finding in findings:
        assert finding["name"] in tool_parser.FINDINGS
        assert not finding.get("filename") or info["filename"].endswith(finding["filename"][4:]) # as finding["filename"].startswith("/sb/")
        finding["filename"] = info["filename"]

    return {
        "findings": findings,
        "infos": sorted(infos),
        "errors": sorted(errors),
        "fails": sorted(fails),
        "parser": {
            "id": tool_id,
            "mode": tool_mode,
            "version": tool_parser.VERSION
            }
        }

