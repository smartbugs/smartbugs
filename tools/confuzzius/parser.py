import io
import json
import tarfile
import sb.parse_utils

VERSION = "2022/12/09"

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


def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:

            # access specific file
            file = tar.extractfile("results.json")

            # convert file into dictionary
            results = json.load(file)

            for contract, data in results.items():
                for errs in data['errors'].values():
                    for issue in errs:
                        finding = dict()

                        finding['contract'] = contract
                        finding['name'] = issue['type']
                        finding['severity'] = issue['severity']
                        finding['line'] = issue['line']
                        finding['message'] = f"Classification: SWC-{issue['swc_id']}"

                        findings.append(finding)
    except Exception as e:
        fails.add(f"error parsing results: {e}")

    return findings, infos, errors, fails
