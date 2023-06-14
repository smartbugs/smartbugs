import os, importlib.util
import sb.cfg, sb.errors

tool_parsers = {}

def get_parser(tool):
    tid,tmode = tool["id"],tool["mode"]
    key = (tid,tmode)
    if  key not in tool_parsers:
        try:
            modulename = f"tools.{tid}.{tmode}"
            fn = os.path.join(sb.cfg.TOOLS_HOME, tid, tool["parser"])
            spec = importlib.util.spec_from_file_location(modulename, fn)
            module = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(module)
            tool_parsers[key] = module
        except Exception as e:
            raise sb.errors.SmartBugsError(f"Cannot load parser for {tid}/{tmode}\n{e}")
    return tool_parsers[key]



def parse(task_log, tool_log, tool_output):
    tool = task_log["tool"]
    filename = task_log["filename"]
    exit_code = task_log["result"]["exit_code"]

    tool_parser = get_parser(tool)
    try:
        findings,infos,errors,fails = tool_parser.parse(exit_code, tool_log, tool_output)
        for finding in findings:
            # if FINDINGS is defined, ensure that the current finding is in FINDINGS
            # irrelevant for SmartBugs, but may be relevant for programs further down the line
            if tool_parser.FINDINGS and finding["name"] not in tool_parser.FINDINGS:
                raise sb.errors.SmartBugsError(f"'{finding['name']}' not among the findings of {tool['id']}")
            # check that filename within docker corresponds to filename outside, before replacing it
            # splitting at "/" is ok, since it is a Linux path from within the docker container
            assert not finding.get("filename") or filename.endswith(finding["filename"].split("/")[-1])
            finding["filename"] = filename
    except Exception as e:
        raise sb.errors.SmartBugsError(f"Parsing of results failed\n{e}")


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

