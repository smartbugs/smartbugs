"""Reduce a Solidity file to its main contract, for SmartBugs' MAIN option.

At ``MAIN=1`` SmartBugs asks a tool to analyse only the *main contract* of a
file --- the one the file is named after --- rather than every library,
interface and base contract a flattened source drags along. Tools that take a
contract name on their command line implement this by passing it on; mythril
and honeybadger do exactly that and exit 127 when the file name matches no
contract.

GPTScan and LLMSmartAudit offer no such selection: GPTScan is handed a source
*directory* and analyses whatever compiles in it, LLMSmartAudit is handed a
source *file* and reads it as text. For them the restriction has to happen
before the call, on the input itself. This script does that.

What it does
------------
It finds the top-level definitions of a file by matching braces over a copy in
which comments and string literals have been blanked out, resolves which one
the file is named after, computes the definitions that one transitively
mentions, and removes the byte ranges of all the others.

Removal, never rewriting: everything that is not a discarded definition
survives unchanged --- licence header, pragma, imports, free functions, the
text between definitions. The dependency closure is an over-approximation (any
top-level name occurring anywhere in a kept definition keeps that definition,
including in an unrelated position), so it errs towards keeping too much. With
``--verify-compile`` the result is additionally handed to solc, and the full
source is restored if it no longer compiles. The reduction can therefore cost
context, but not a run.

Usage
-----
::

    python main_contract.py [--verify-compile] SRC DST
    python main_contract.py --list SRC

The entrypoint ``do_solidity.sh`` of each tool calls it at ``MAIN=1`` with the
file SmartBugs passed in as SRC and a path under ``$TMPDIR/sb_main`` as DST.
GPTScan's entrypoint adds ``--verify-compile``; LLMSmartAudit's calls it
without the flag, because that image has no solc.

Exit codes
----------
0    the target file was written (reduced, or restored in full after a failed
     verification)
127  the file name matched no top-level definition. SmartBugs reserves this
     code for precisely this case and reports it as the fail "SmartBugs was
     invoked with option 'main', but the filename did not match any contract"
     (``sb/parse_utils.py``).
1    the script itself failed

This file is duplicated into every tool that needs it, because SmartBugs copies
each tool's ``bin:`` directory into the container separately --- the same
reason ``printContractNames.py`` exists twenty times upstream. The copies are
kept identical; the two copies must not diverge.
"""

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from collections import namedtuple

Definition = namedtuple("Definition", "kind name start end")

# The three kinds of top-level definition that carry a body and a name. Free
# functions, structs, enums, constants and errors are deliberately absent: they
# are never dropped, because only definitions found here can be dropped at all.
DEFINITION = re.compile(
    r"\b(?:abstract\s+)?(contract|interface|library)\s+([A-Za-z_$][A-Za-z0-9_$]*)"
)
IDENTIFIER = re.compile(r"[A-Za-z_$][A-Za-z0-9_$]*")

# Some corpora name their files "<number>_<Original>.sol". The stem behind the
# number is the original Solidity file name, which is what the naming
# convention refers to.
CORPUS_PREFIX = re.compile(r"^\d+_")


def blank_noncode(source):
    """Return *source* with comments and string literals replaced by spaces.

    Offsets and line breaks are preserved, so positions found in the result are
    valid in the original. Without this a contract name mentioned in a comment
    would keep a definition alive, and the word "contract" inside a string
    would look like a definition.
    """
    out = []
    i, n = 0, len(source)
    while i < n:
        c = source[i]
        two = source[i : i + 2]
        if two == "//":
            while i < n and source[i] != "\n":
                out.append(" ")
                i += 1
        elif two == "/*":
            while i < n and source[i : i + 2] != "*/":
                out.append("\n" if source[i] == "\n" else " ")
                i += 1
            for _ in range(min(2, n - i)):
                out.append(" ")
                i += 1
        elif c in "\"'":
            quote = c
            out.append(" ")
            i += 1
            while i < n and source[i] != quote:
                if source[i] == "\\" and i + 1 < n:
                    out.append(" ")
                    i += 1
                out.append("\n" if source[i] == "\n" else " ")
                i += 1
            if i < n:
                out.append(" ")
                i += 1
        else:
            out.append(c)
            i += 1
    return "".join(out)


def top_level_definitions(source):
    """The contracts, interfaces and libraries of *source*, in file order.

    ``start``/``end`` delimit the whole definition including its body, found by
    matching braces rather than by counting lines: bodies contain braces, and
    the corpus files are flattened, so a definition can span thousands of
    lines.
    """
    code = blank_noncode(source)
    candidates = {}
    for match in DEFINITION.finditer(code):
        candidates[match.start()] = match

    definitions = []
    depth = 0
    i, n = 0, len(code)
    while i < n:
        match = candidates.get(i) if depth == 0 else None
        if match is not None:
            body = code.find("{", match.end())
            if body != -1:
                end = _match_brace(code, body)
                if end is not None:
                    definitions.append(
                        Definition(match.group(1), match.group(2), match.start(), end)
                    )
                    i = end
                    continue
        if code[i] == "{":
            depth += 1
        elif code[i] == "}":
            depth = max(0, depth - 1)
        i += 1
    return definitions


def _match_brace(code, opening):
    """Index just past the ``}`` closing the ``{`` at *opening*, or None."""
    depth = 0
    for i in range(opening, len(code)):
        if code[i] == "{":
            depth += 1
        elif code[i] == "}":
            depth -= 1
            if depth == 0:
                return i + 1
    return None


def resolve_main_name(stem, names):
    """Which definition is *stem* the name of, or None.

    Three steps, most specific first. The plain stem is SmartBugs' own
    convention. A numbering prefix (``<number>_``) comes off next, for corpora
    that name their files that way; without this step the convention would
    resolve nothing in such a corpus. The case-insensitive step covers file names
    that differ from their contract only in capitalisation (``yVault.sol``
    holds ``contract YVault``) and gives up when more than one definition
    qualifies, because then the file name does not identify one contract.
    """
    names = list(names)
    if stem in names:
        return stem
    base = CORPUS_PREFIX.sub("", stem)
    if base in names:
        return base
    folded = [n for n in names if n.lower() == base.lower()]
    return folded[0] if len(folded) == 1 else None


def reduce_source(source, main_name):
    """*source* with every definition the main contract does not need removed.

    Raises KeyError if *main_name* is not a top-level definition of *source*.
    """
    definitions = sorted(top_level_definitions(source), key=lambda d: d.start)
    by_name = {d.name: d for d in definitions}
    if main_name not in by_name:
        raise KeyError(main_name)

    code = blank_noncode(source)
    mentioned = {d.name: set(IDENTIFIER.findall(code[d.start : d.end])) for d in definitions}

    # Text outside every definition is always kept, so whatever it names is
    # needed too -- a top-level "using X for Y" or a free function body.
    outside = set()
    position = 0
    for d in definitions:
        outside.update(IDENTIFIER.findall(code[position : d.start]))
        position = d.end
    outside.update(IDENTIFIER.findall(code[position:]))

    keep = {main_name} | (outside & set(by_name))
    pending = list(keep)
    while pending:
        for name in mentioned.get(pending.pop(), ()):
            if name in by_name and name not in keep:
                keep.add(name)
                pending.append(name)

    kept, position = [], 0
    for d in definitions:
        if d.name in keep:
            continue
        kept.append(source[position : d.start])
        position = d.end
    kept.append(source[position:])
    return "".join(kept)


def compiles(path):
    """Does solc accept *path*? None when solc could not be asked at all.

    Mirrors the standard-json invocation of ``printContractNames.py``, so the
    verification uses the same compiler SmartBugs picked for the pragma.
    """
    request = json.dumps(
        {
            "language": "Solidity",
            "sources": {path: {"urls": [path]}},
            "settings": {
                "optimizer": {"enabled": False},
                "outputSelection": {"*": {"*": []}},
            },
        }
    )
    solc = shutil.which("solc")
    if solc is None:
        return None
    try:
        process = subprocess.Popen(
            [solc, "--standard-json", "--allow-paths", ".,/"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        stdout, _ = process.communicate(request.encode("utf-8"))
        report = json.loads(stdout.decode("utf-8", "replace"))
    except (OSError, ValueError):
        return None
    return not any(e.get("severity") == "error" for e in report.get("errors", []))


def main(argv=None):
    """Command line: read SRC, resolve the main contract from the file name
    and write the reduction to DST.

    Returns 0 when DST was written (reduced, or restored in full after a
    failed ``--verify-compile``), 127 when the name matches no definition
    (nothing is written); with ``--list`` only the definition names are
    printed.
    """
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("source", help="the .sol file SmartBugs passed in")
    parser.add_argument("target", nargs="?", help="where to write the reduction")
    parser.add_argument(
        "--list", action="store_true", help="print the top-level definition names and stop"
    )
    parser.add_argument(
        "--verify-compile",
        action="store_true",
        help="restore the full source if the reduction no longer compiles (needs solc on PATH)",
    )
    args = parser.parse_args(argv)

    with open(args.source, encoding="utf-8", errors="replace") as fh:
        source = fh.read()
    definitions = top_level_definitions(source)

    if args.list:
        for d in definitions:
            print(d.name)
        return 0
    if not args.target:
        parser.error("a target path is required unless --list is given")

    stem = os.path.basename(args.source)
    if stem.endswith(".sol"):
        stem = stem[:-4]
    main_name = resolve_main_name(stem, [d.name for d in definitions])
    if main_name is None:
        print(
            f"MAIN: '{stem}' names none of the {len(definitions)} definitions "
            f"in {os.path.basename(args.source)}"
        )
        return 127

    reduced = reduce_source(source, main_name)
    with open(args.target, "w", encoding="utf-8") as fh:
        fh.write(reduced)

    before, after = len(source.splitlines()), len(reduced.splitlines())
    if args.verify_compile and compiles(args.target) is False:
        with open(args.target, "w", encoding="utf-8") as fh:
            fh.write(source)
        print(
            f"MAIN: reduction to '{main_name}' does not compile, fallback to the full "
            f"source ({before} lines)"
        )
        return 0

    print(
        f"MAIN: '{main_name}', {len(top_level_definitions(reduced))} of "
        f"{len(definitions)} definitions kept, {after} of {before} lines"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
