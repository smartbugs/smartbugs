import io
import json
import tarfile
import sb.parse_utils

VERSION = "2022/12/10"

FINDINGS = {
    "Assertion Failure",
    "Integer Overflow",
    "Reentrancy",
    "Transaction Order Dependency",
    "Block Dependency",
    "Unhandled Exception",
    "Unsafe Delegatecall",
    "Leaking Ether",
    "Locking Ether",
    "Unprotected Selfdestruct",
}


def is_relevant(line):
    # Remove logo for exception parsing
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
            errors.add(msg[3])

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
