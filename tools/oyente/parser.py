import re
import sb.parse_utils

VERSION = "2022/08/06"

FINDINGS = {
    "Callstack Depth Attack Vulnerability",
    "Transaction-Ordering Dependence (TOD)",
    "Timestamp Dependency",
    "Re-Entrancy Vulnerability",
}

INFOS = (
    re.compile("!!! (SYMBOLIC EXECUTION TIMEOUT) !!!"),
    re.compile("(incomplete push instruction) at [0-9]+"),
)

# ERRORS also for Osiris and Honeybadger
ERRORS = (
    re.compile("(UNKNOWN INSTRUCTION: .*)"),
    re.compile("CRITICAL:root:(Solidity compilation failed)"),
)

FAILS = (
#    re.compile("(Unexpected error: .*)"), # Secondary error
)

def is_relevant(line):
    # Identify lines interfering with exception parsing
    return not (
        line.startswith("888")
        or line.startswith("`88b")
        or line.startswith("!!! ")
        or line.startswith("UNKNOWN INSTRUCTION:")
    )


def parse(exit_code, log, output, task, FINDINGS=FINDINGS):

    findings, infos, analysis = set(), set(), []
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)
    errors.discard('EXIT_CODE_1') # redundant: indicates error or vulnerability reported below

    analysis_completed = False
    contract = None
    for line in log:
        if sb.parse_utils.add_match(infos, line, INFOS):
            continue
        if sb.parse_utils.add_match(errors, line, ERRORS):
            continue
        if sb.parse_utils.add_match(fails, line, FAILS):
            continue

        fields = [ f.strip().replace('└> ','') for f in line.split(':') ]
        if (line.startswith('INFO:root:contract') or line.startswith('INFO:root:Contract')) and len(fields) >= 4:
            # INFO:root:contract <filename>:<contract name>:
            if contract is not None:
                analysis.append(contract)
            contract = {
                'file': fields[2].replace('contract ', '').replace('Contract ',''),
                'contract': fields[3]
            }
            key = None
            val = None
            analysis_completed = False
        elif line.startswith('INFO:symExec:\t'):
            if fields[2] == '============ Results ===========':
                # INFO:symExec:   ============ Results ===========
                pass
            elif fields[2] == '====== Analysis Completed ======':
                # INFO:symExec:   ====== Analysis Completed ======
                analysis_completed = True
            elif len(fields) >= 4:
                # INFO:symExec:<key>:<value>
                if contract is None:
                    contract = {}
                key = fields[2]
                val = fields[3]
                if val == 'True':
                    contract[key] = True
                    findings.add(key)
                elif val == 'False':
                    contract[key] = False
                else:
                    contract[key] = val
        elif contract is not None and 'file' in contract:
            fn = contract['file']
            if 'issues' not in contract:
                contract['issues'] = []
            if line.startswith(f"INFO:symExec:{fn}") and len(fields) >= 7:
                # INFO:symExec:<filename>:<line>:<column>:<level>:<message>
                contract['issues'].append({
                    'line':    int(fields[3]),
                    'column':  int(fields[4]),
                    'level':   fields[5],
                    'message': fields[6]
                })
            elif line.startswith(fn) and len(fields) >= 5:
                # <filename>:<line>:<column>:<level>:<message>
                contract['issues'].append({
                    'line':    int(fields[1]),
                    'column':  int(fields[2]),
                    'level':   fields[3],
                    'message': fields[4]
                })
            elif line.startswith(fn) and len(fields) >= 4:
                # <filename>:<contract>:<line>:<column>
                assert 'contract' in contract and contract['contract'] == fields[1]
                assert key is not None and val == 'True'
                contract['issues'].append({
                    'line':    int(fields[2]),
                    'column':  int(fields[3]),
                    'message': key
                })
    if contract is not None:
            analysis.append(contract)

    if log and not analysis_completed:
        infos.add('analysis incomplete')
        if not fails and not errors:
            fails.add('execution failed')

    # Remove errors/fails issued twice, once via exception and once via print statement
    # Reclassify symbolic execution timeouts, as they are informative rather than an error
    if "SYMBOLIC EXECUTION TIMEOUT" in infos and "exception (Exception: timeout)" in fails:
        fails.remove("exception (Exception: timeout)")
    if "exception (Exception: timeout)" in fails:
        infos.add("exception (Exception: timeout)")
    for e in list(fails): # list() makes a copy, so we can modify the set in the loop
        if "UNKNOWN INSTRUCTION" in e:
            fails.remove(e)
            if not e[22:-1] in errors:
                errors.add(e)

    return findings, infos, errors, fails, analysis
