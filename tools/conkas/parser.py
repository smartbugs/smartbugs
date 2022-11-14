import re
import sb.parse_utils

VERSION = "2022/11/11"

FINDINGS = {
    "Integer Overflow",
    "Integer Underflow",
    "Reentrancy",
    "Time Manipulation",
    "Transaction Ordering Dependence",
    "Unchecked Low Level Call"
}

ERRORS = (
    re.compile("([A-Z0-9]+ instruction needs return value)"),
    re.compile("([A-Z0-9]+ instruction needs [0-9]+ arguments but [0-9]+ was given)"),
    re.compile("([A-Z0-9]+ instruction need arguments but [0-9]+ was given)"),
    re.compile("([A-Z0-9]+ instruction needs a concrete argument)"),
    re.compile("([A-Z0-9]+ instruction should not be reached)"),
    re.compile("([A-Z0-9]+ instruction is not implemented)"),
    re.compile("(Cannot get source map runtime\. Check if solc is in your path environment variable)"),
    re.compile("(Vulnerability module checker initialized without traces)"),
    re.compile(".*(solcx.exceptions.SolcError:.*)")
)

ANALYSING = re.compile("^Analysing (.*)\.\.\.$")
VULNERABILITY = re.compile("^Vulnerability: (.*)\. Maybe in function: (.*)\. PC: 0x(.*)\. Line number: (.*)\.$")


def is_relevant(line):
    return not ANALYSING.match(line)


def parse(exit_code, log, output):
    findings, infos = [], set()
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)

    for f in list(fails): # iterate over a copy of "fails" such that it can be modified
        if f.startswith("exception (KeyError: <SSABasicBlock"):
            fails.remove(f)
            fails.add("exception (KeyError: <SSABasicBlock ...>)")
        if f.startswith("exception (RecursionError: maximum recursion depth exceeded while calling a Python object)"):
            # Normalize two types of recursion errors to the shorter one.
            fails.remove(f)
            fails.add("exception (RecursionError: maximum recursion depth exceeded)")

    filename,contract = None,None
    for line in log:
        if sb.parse_utils.add_match(errors, line, ERRORS):
            fails.discard("exception (Exception)")
            continue
        m = ANALYSING.match(line)
        if m:
            filename,contract = m[1].split(":") if ":" in m[1] else (m[1],None)
        m = VULNERABILITY.match(line)
        if m:
            finding = { "name": m[1] }
            if filename: finding["filename"] = filename
            if contract: finding["contract"] = contract
            if m[2]:     finding["function"] = m[2]
            if m[3]:     finding["address"]  = int(m[3],16)
            if m[4]:     finding["line"]   = int(m[4])
            findings.append(finding)

    return findings, infos, errors, fails

