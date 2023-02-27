import re
import sb.parse_utils

VERSION = "2023/02/27"

FINDINGS = {
    "Callstack Depth Attack Vulnerability",
    "Transaction-Ordering Dependence (TOD)",
    "Timestamp Dependency",
    "Re-Entrancy Vulnerability",
    "Integer Overflow",
    "Integer Underflow",
    "Parity Multisig Bug 2"
}

INFOS = (
    re.compile("(incomplete push instruction) at [0-9]+"),
)

# ERRORS also for Osiris and Honeybadger
ERRORS = (
    re.compile("!!! (SYMBOLIC EXECUTION TIMEOUT) !!!"),
    re.compile("(UNKNOWN INSTRUCTION: .*)"),
    re.compile("CRITICAL:root:(Solidity compilation failed)"),
)

FAILS = (
#    re.compile("(Unexpected error: .*)"), # Secondary error
)

CONTRACT  = re.compile("^INFO:root:[Cc]ontract ([^:]*):([^:]*):")
WEAKNESS  = re.compile("^INFO:symExec:[\s└>]*([^:]*):\s*True")
LOCATION1 = re.compile("^INFO:symExec:([^:]*):([0-9]+):([0-9]+):\s*([^:]*):\s*(.*)\.") # Oyente
LOCATION2 = re.compile("^([^:]*):([^:]*):([0-9]+):([0-9]+)") # Osiris
COMPLETED = re.compile("^INFO:symExec:\s*====== Analysis Completed ======")


def is_relevant(line):
    # Identify lines interfering with exception parsing
    return not (
        line.startswith("888")
        or line.startswith("`88b")
        or line.startswith("!!! ")
        or line.startswith("UNKNOWN INSTRUCTION:")
    )


def parse(exit_code, log, output):

    findings, infos = [], set()
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)
    errors.discard('EXIT_CODE_1') # redundant: indicates error or vulnerability reported below

    analysis_completed = False
    filename,contract,weakness = None,None,None
    weaknesses = set()
    for line in log:
        if sb.parse_utils.add_match(infos, line, INFOS):
            continue
        if sb.parse_utils.add_match(errors, line, ERRORS):
            continue
        if sb.parse_utils.add_match(fails, line, FAILS):
            continue

        m = CONTRACT.match(line)
        if m:
            filename, contract = m[1], m[2]
            analysis_completed = False
            continue

        m = WEAKNESS.match(line)
        if m:
            weakness = m[1]
            if weakness == "Arithmetic bugs":
                # Osiris: superfluous, will also report a sub-category
                continue
            weaknesses.add((filename,contract,weakness,None,None))
            continue

        m = LOCATION1.match(line)
        if m:
            fn, lineno, column, severity, weakness = m[1], m[2], m[3], m[4], m[5]
            weaknesses.discard((filename,contract,weakness,None,None))
            weaknesses.add((filename,contract,weakness,int(lineno),int(column)))
            continue

        m = LOCATION2.match(line)
        if m:
            fn, ct, lineno, column = m[1], m[2], m[3], m[4]
            assert fn == filename and ct == contract and weakness is not None
            weaknesses.discard((filename,contract,weakness,None,None))
            weaknesses.add((filename,contract,weakness,int(lineno),int(column)))
            continue

        m = COMPLETED.match(line)
        if m:
            analysis_completed = True
            continue

    for filename,contract,weakness,lineno,column in sorted(weaknesses):
        finding = { "name": weakness }
        if filename: finding["filename"] = filename
        if contract: finding["contract"] = contract
        if lineno:   finding["line"]   = lineno
        if column:   finding["column"]   = column
        findings.append(finding)
            
    if log and not analysis_completed:
        infos.add('analysis incomplete')
        if not fails and not errors:
            fails.add('execution failed')

    # Remove errors/fails issued twice, once via exception and once via print statement
    # Reclassify symbolic execution timeouts, as they are informative rather than an error
    if "SYMBOLIC EXECUTION TIMEOUT" in errors and "exception (Exception: timeout)" in fails:
        fails.remove("exception (Exception: timeout)")
    #if "exception (Exception: timeout)" in fails:
    #    infos.add("exception (Exception: timeout)")
    for e in list(fails): # list() makes a copy, so we can modify the set in the loop
        if "UNKNOWN INSTRUCTION" in e:
            fails.remove(e)
            if not e[22:-1] in errors:
                errors.add(e)

    return findings, infos, errors, fails
