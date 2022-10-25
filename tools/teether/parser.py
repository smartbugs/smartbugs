import re
import sb.parse_utils

VERSION = "2022/08/05"

FINDINGS = { "Ether leak" }

FAILED_PATH = re.compile("Failed path due to (.*)")

ERRORS = (
    "Failed path due to Symbolic code index",
    "Failed path due to balance of symbolic address"
)

MESSAGES = (
    ("INFO:root:Could not exploit any RETURN+CALL", "Could not exploit any RETURN+CALL"),
    ("WARNING:root:No state-dependent critical path found, aborting", "No state-dependent critical path found"),
)


def parse(exit_code, log, output, info):
    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    errors.discard('EXIT_CODE_1') # there will be an exception in fails anyway
    for f in list(fails):         # make a copy of fails, so we can modify it
        if f.startswith("exception (teether.evm.exceptions."): # reported as error below
            fails.remove(f)
        elif f.startswith("exception (z3.z3types.Z3Exception: b'Argument "):
            fails.remove(f)
            fails.add("exception (z3.z3types.Z3Exception: Argument does not match function declaration")

    exploit = []
    analysis_completed = False
    for line in log:
        if line.startswith("INFO:root:Could not exploit any RETURN+CALL"):
            infos.add("Could not exploit any RETURN+CALL")
            analysis_completed = True
        elif line.startswith("WARNING:root:No state-dependent critical path found, aborting"):
            infos.add("No state-dependent critical path found")
            analysis_completed = True
        elif line.startswith("eth.sendTransaction"):
            exploit.append(line)
            findings.add("Ether leak")
            analysis_completed = True
        elif line.startswith("ERROR:root:"):
            error = line[11:]
            # Skip errors already reported as an exception
            if error.startswith("Failed path due to b'Argument "):
                continue
            m = FAILED_PATH.match(error)
            if m and any(m[1] in f for f in fails):
                continue
            for e in ERRORS:
                if error.startswith(e):
                    error = e
                    break
            errors.add(error)

    if log and not analysis_completed:
        infos.add('analysis incomplete')
    if not fails and not errors:
        fails.add('execution failed')
    analysis = [ { 'exploit': exploit } ] if exploit else [ {} ]

    return findings, infos, errors, fails, analysis

