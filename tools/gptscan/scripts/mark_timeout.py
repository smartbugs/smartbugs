#!/usr/bin/env python3
"""Stamp the sb_timeout marker onto a tool report that was cut short.

Called by the entrypoint when the net fired: the tool was stopped from the
outside, so it never got the chance to record that fact itself. When the *brake*
fired instead, the tool writes the marker on its own and this script is not
involved.

Never fails destructively --- a report that cannot be read or written is left
exactly as it is and the reason goes to stderr, where SmartBugs captures it as
part of the log. Losing a partial result to a marker script would defeat the
purpose of the marker.
"""

import json
import sys


def stamp(path, stage, detail=""):
    """Add sb_timeout to the JSON object at *path*. Returns True when written."""
    try:
        with open(path, encoding="utf-8") as fh:
            report = json.load(fh)
    except (OSError, ValueError) as e:
        print(f"mark_timeout: cannot read {path}: {e}", file=sys.stderr)
        return False

    if not isinstance(report, dict):
        print(f"mark_timeout: {path} is not a JSON object", file=sys.stderr)
        return False

    report["sb_timeout"] = {"hit": True, "stage": stage, "detail": detail}

    try:
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(report, fh, indent=2, ensure_ascii=False)
    except OSError as e:
        print(f"mark_timeout: cannot write {path}: {e}", file=sys.stderr)
        return False
    return True


def main(argv):
    """Command line ``mark_timeout.py <report.json> <brake|net> [detail]``.

    *argv* is ``sys.argv`` including the program name. Returns 0 when the
    marker was written, 1 when the report could not be read or written, 2 on
    a usage error.
    """
    if len(argv) < 3:
        print("usage: mark_timeout.py <report.json> <brake|net> [detail]", file=sys.stderr)
        return 2
    stage = argv[2]
    if stage not in ("brake", "net"):
        print(f"mark_timeout: stage must be 'brake' or 'net', got {stage!r}", file=sys.stderr)
        return 2
    detail = argv[3] if len(argv) > 3 else ""
    return 0 if stamp(argv[1], stage, detail) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
