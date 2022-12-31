import io
import json
import tarfile
import sb.parse_utils

VERSION = "2022/12/31"

FINDINGS = {
    "Arbitrary Memory Access",
    "Assertion Failure",
    "Block Dependency",
    "Integer Overflow",
    "Leaking Ether",
    "Locking Ether",
    "Reentrancy",
    "Transaction Order Dependency",
    "Unhandled Exception",
    "Unprotected Selfdestruct",
    "Unsafe Delegatecall",
}


def is_relevant(line):
    # Remove logo when parsing exceptions
    return line and not (
        line.startswith("     _") or
        line.startswith("    /") or
        line.startswith("   /") or
        line.startswith("  /") or
        line.startswith("  \\") )


def parse(exit_code, log, output):
    findings, infos = [], set()
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)

    for line in sb.parse_utils.discard_ANSI(log):
        msg = [ field.strip() for field in line.split(" - ") ]
        if len(msg) >= 4 and msg[2] == "ERROR":
            e = msg[3]
            if e.startswith("Validation error") and e.endswith("Sender account balance cannot afford txn (ignoring for now)"):
                e = "Validation error: Sender account balance cannot afford txn (ignoring for now)"
            errors.add(e)

    if output:
        try:
            with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
                file = tar.extractfile("results.json")
                results = json.load(file)

                for contract, data in results.items():
                    for errs in data['errors'].values():
                        for issue in errs:
                            finding = {
                                "contract": contract,
                                "name": issue["type"],
                                "severity": issue["severity"],
                                "line": issue["line"],
                                "message": f"Classification: SWC-{issue['swc_id']}" }
                            findings.append(finding)
        except Exception as e:
            fails.add(f"error parsing results: {e}")

    return findings, infos, errors, fails
