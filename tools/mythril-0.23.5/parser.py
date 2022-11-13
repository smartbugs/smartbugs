import json
import sb.parse_utils

VERSION = "2022/11/11"

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


def parse(exit_code, log, output):

    findings, infos = [], set()
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
        result = json.loads(log[-1])
    except:
        pass
    if result:
        error = result.get("error")
        if error:
            errors.add(error.split('.')[0])
        for issue in result.get("issues", []):
            finding = { "name": issue["title"] }
            for k in ("filename", "contract", "function", "address", "lineno"):
                if k in issue:
                    finding[k] = issue[k]
            if "tx_sequence" in issue:
                finding["exploit"] = issue["tx_sequence"]
            if "description" in issue:
                finding["description"] = issue["description"]
            if "severity" in issue:
                finding["severity"] = issue["severity"].lower()
            if "swc-id" in issue:
                finding["classification"] = f"SWC-{issue['swc-id']}"
            findings.append(finding)

    return findings, infos, errors, fails

