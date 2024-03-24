import json
import sb.parse_utils

VERSION = "2024/03/24"

FINDINGS = {
    "Jump to an arbitrary instruction (SWC 127)",
    "Write to an arbitrary storage location (SWC 124)",
    "Delegatecall to user-supplied address (SWC 112)",
    "Dependence on tx.origin (SWC 115)",
    "Dependence on predictable environment variable (SWC 116)",
    "Dependence on predictable environment variable (SWC 120)",
    "Unprotected Ether Withdrawal (SWC 105)",
    "Exception State (SWC 110)",
    "External Call To User-Supplied Address (SWC 107)",
    "Integer Arithmetic Bugs (SWC 101)",
    "Multiple Calls in a Single Transaction (SWC 113)",
    "State access after external call (SWC 107)",
    "Unprotected Selfdestruct (SWC 106)",
    "Unchecked return value from external call. (SWC 104)",
    "Transaction Order Dependence (SWC 114)",
    "requirement violation (SWC 123)",
    "Strict Ether balance check (SWC 132)"
}


def parse(exit_code, log, output):

    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard("EXIT_CODE_1") # exit code = 1 just means that a weakness has been found

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
        result = None
    if result:
        error = result.get("error")
        if error:
            errors.add(error.split('.')[0])
        for issue in result.get("issues", []):
            finding = { "name": issue["title"] }
            for i,f in ( ("filename","filename"), ("contract","contract"),
                ("function","function"), ("address","address"), ("lineno", "line"),
                ("tx_sequence","exploit"), ("description","message"), ("severity","severity") ):
                if i in issue:
                    finding[f] = issue[i]
            if "swc-id" in issue:
                finding["name"] += f" (SWC {issue['swc-id']})"
                classification = f"Classification: SWC-{issue['swc-id']}"
                if finding.get("message"):
                    finding["message"] += f"\n{classification}"
                else:
                    finding["message"] = classification
            findings.append(finding)

    return findings, infos, errors, fails

