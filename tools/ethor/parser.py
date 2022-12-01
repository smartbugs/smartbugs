import re
import sb.parse_utils

VERSION = "2022/11/11"

FINDINGS = ("secure", "insecure")

UNKNOWN_BYTECODE = "Encountered an unknown bytecode"

FAILS = (
    re.compile("OpenJDK.* failed; error='([^']+)'"),
    re.compile("(Floating-point arithmetic exception) signal in rule"),
    re.compile(".*(Undefined relation [a-zA-Z0-9]+) in file .*dl at line"),
)

UNSUPPORTED_OP = re.compile(".*(java.lang.UnsupportedOperationException: [^)]*)\)")

COMPLETED = re.compile("^(.*) (secure|insecure|unknown)$")

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard('EXIT_CODE_1') # redundant: exit code 1 is reflected in other errors
    if 'DOCKER_TIMEOUT' in fails or 'DOCKER_KILL_OOM' in fails:
        fails.discard('exception (Killed)')
    # "Unsupported Op" is a regular, checked-for errors, not an unexpected fails
    for e in list(fails):
        m = UNSUPPORTED_OP.match(e)
        if m:
            fails.remove(e)
            errors.add(m[1])

    analysis_complete = False
    for line in log:
        if UNKNOWN_BYTECODE in line:
            infos.add(UNKNOWN_BYTECODE)
            continue
        if sb.parse_utils.add_match(fails, line, FAILS):
            continue
        if line.endswith(" unknown"):
            analysis_complete = True
            continue
        m = COMPLETED.match(line)
        if m:
            analysis_complete = True
            if m[2] in FINDINGS:
                findings.append({"filename": m[1], "name": m[2]})
            continue
    if "DOCKER_SEGV" in fails:
        fails.discard("exception (Segmentation fault)")

    if log and not analysis_complete:
        infos.add('analysis incomplete')
        if not fails and not errors:
            fails.add('execution failed')

    return findings, infos, errors, fails
