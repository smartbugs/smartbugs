import json
import sb.parse_utils

VERSION = "2022/08/06"

FINDINGS = {
    "Jump to an arbitrary instruction",
    "Write to an arbitrary storage location",
    "Delegatecall to user-supplied address",
    "Dependence on tx.origin",
    "Dependence on predictable environment variable",
    "Unprotected Ether Withdrawal",
    "Exception State",
    "External Call To User-Supplied Address",
    "Integer Arithmetic Bugs",
    "Multiple Calls in a Single Transaction",
    "State access after external call",
    "Unprotected Selfdestruct",
    "Unchecked return value from external call.",
}


def parse(exit_code, log, output, task):

    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    # Mythril catches all exceptions, prints a message "please report", and then prints the traceback.
    # So we consider all exceptions as fails (= non-intended interruptions)
    for f in list(fails): # iterate over a copy of 'fails' such that it can be modified
        if f.startswith("exception (mythril.laser.ethereum.transaction.transaction_models.TransactionEndSignal"):
            fails.remove(f)
            fails.add("exception (mythril.laser.ethereum.transaction.transaction_models.TransactionEndSignal)")

    for line in log:
        if "Exception occurred, aborting analysis." in line:
            infos.add("analysis incomplete")
            if not fails and not errors:
                fails.add("execution failed")
                break

    try:
        analysis = json.loads(log[-1])
    except:
        pass
    if analysis:
        issues = analysis.get("issues", [])
        findings.update([issue["title"] for issue in issues])
        error = analysis.get("error")
        if error:
            errors.add(error.split('.')[0])

    return findings, infos, errors, fails, analysis

