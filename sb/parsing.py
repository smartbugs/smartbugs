import importlib.util
import os
from typing import TYPE_CHECKING, Any, Optional

import sb.cfg
import sb.errors


if TYPE_CHECKING:
    from types import ModuleType

tool_parsers: dict[tuple[str, str], "ModuleType"] = {}


def get_parser(tool: dict[str, Any]) -> "ModuleType":
    tid, tmode = tool["id"], tool["mode"]
    key = (tid, tmode)
    if key not in tool_parsers:
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


def parse(
    task_log: dict[str, Any], tool_log: Optional[list[str]], tool_output: Optional[bytes]
) -> dict[str, Any]:
    """Parse tool execution results into standardized findings format.

    This function provides the stable interface between SmartBugs core and tool parsers.
    All 30+ tool parsers expect these exact types - DO NOT CHANGE without updating all parsers.

    Args:
        task_log: Task metadata including tool info, filename, exit code
        tool_log: Tool's stdout/stderr as list of lines (NOT a single string)
        tool_output: Tool's binary output file (NOT decoded to string)

    Returns:
        Dictionary with findings, infos, errors, fails, and parser metadata

    Interface Contract:
        - tool_log MUST be list[str] or None (parsers iterate: "for line in log")
        - tool_output MUST be bytes or None (parsers use: "io.BytesIO(output)")
        - Changing these types requires updating ALL tool parsers in tools/*/parser.py
    """
    tool = task_log["tool"]
    filename = task_log["filename"]
    exit_code = task_log["result"]["exit_code"]

    tool_parser = get_parser(tool)
    try:
        findings, infos, errors, fails = tool_parser.parse(exit_code, tool_log, tool_output)
        for finding in findings:
            # if FINDINGS is defined, ensure that the current finding is in FINDINGS
            # irrelevant for SmartBugs, but may be relevant for programs further down the line
            if tool_parser.FINDINGS and finding["name"] not in tool_parser.FINDINGS:
                raise sb.errors.SmartBugsError(
                    f"'{finding['name']}' not among the findings of {tool['id']}"
                )
            # check that filename within docker corresponds to filename outside, before replacing it
            # splitting at "/" is ok, since it is a Linux path from within the docker container
            assert not finding.get("filename") or filename.endswith(
                finding["filename"].split("/")[-1]
            )
            finding["filename"] = filename
    except Exception:
        raise
        # raise sb.errors.SmartBugsError(f"Parsing of results failed\n{e}")

    return {
        "findings": findings,
        "infos": sorted(infos),
        "errors": sorted(errors),
        "fails": sorted(fails),
        "parser": {"id": tool["id"], "mode": tool["mode"], "version": tool_parser.VERSION},
    }
