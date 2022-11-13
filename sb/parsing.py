import sys, os, importlib.util
from sb.exceptions import SmartBugsError
import sb.config, sb.io

tool_parsers = {}

def get_parser(tool):
    tid,tmode = tool["id"],tool["mode"]
    key = (tid,tmode)
    if  key not in tool_parsers:
        try:
            modulename = f"tools.{tid}.{tmode}"
            fn = os.path.join(sb.config.TOOLS_HOME, tid, tool["parser"])
            spec = importlib.util.spec_from_file_location(modulename, fn)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            tool_parsers[key] = module
        except Exception as e:
            raise SmartBugsError(f"Cannot load parser for {tid}/{tmode}\n{e}")
    return tool_parsers[key]



def parse(filename, tool, exit_code, log, output):
    tool_parser = get_parser(tool)

    try:
        findings,infos,errors,fails = tool_parser.parse(exit_code, log, output)
    except Exception as e:
        raise SmartBugsError(f"Parsing the result of analysis failed\n{e}")

    for finding in findings:
        # ensure that tool_parser.FINDINGS is complete; otherwise irrelevant
        assert finding["name"] in tool_parser.FINDINGS
        # check that the docker filename equals the external name (except for /sb/), before overwriting it
        assert not finding.get("filename") or filename.endswith(finding["filename"][4:])
        finding["filename"] = filename

    return {
        "findings": findings,
        "infos": sorted(infos),
        "errors": sorted(errors),
        "fails": sorted(fails),
        "parser": {
            "id": tool["id"],
            "mode": tool["mode"],
            "version": tool_parser.VERSION
            }
        }

