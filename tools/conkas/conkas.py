import re
import sb.parse_utils

VERSION = "2022/08/12"

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

def skip(line):
    # Identify lines interfering with exception parsing
    return line.startswith("Analysing ") and line.endswith("...")

def parse(exit_code, log, output, info):
    findings, infos, errors, fails, analysis = sb.parse_utils.init(exit_code, log, skip=skip)

    for f in list(fails):
        if f.startswith("exception (KeyError: <SSABasicBlock"):
            fails.remove(f)
            fails.add("exception (KeyError: <SSABasicBlock ...>)")
        if f.startswith("exception (RecursionError: maximum recursion depth exceeded while calling a Python object)"):
            # Normalize two types of recursion errors to the shorter one.
            fails.remove(f)
            fails.add("exception (RecursionError: maximum recursion depth exceeded)")

    for line in log:
        if sb.parse_utils.add_match(errors, line, ERRORS):
            fails.discard('exception (Exception)')
            continue
        if 'Vulnerability: ' in line:
            vuln_type = line.split('Vulnerability: ')[1].split('.')[0]
            maybe_in_function = line.split('Maybe in function: ')[1].split('.')[0]
            pc = line.split('PC: ')[1].split('.')[0]
            line_number = line.split('Line number: ')[1].split('.')[0]
            analysis.append({
                'vuln_type': vuln_type,
                'maybe_in_function': maybe_in_function,
                'pc': pc,
                'line_number': line_number
            })
            findings.add(vuln_type)

    return findings, infos, errors, fails, analysis

