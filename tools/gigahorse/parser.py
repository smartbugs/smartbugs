import io
import json
import tarfile

import sb.parse_utils


VERSION = "2022/11/17"


def parse(
    exit_code: int, log: list[str], output: bytes, findings: set[str]
) -> tuple[list[dict], set[str], set[str], set[str]]:
    findings_list, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if "Writing results to results.json" not in log:
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            results_json = tar.extractfile("results.json").read()
        result = json.loads(results_json)
        for contract in result:
            filename = contract[0]
            errors.update(contract[2])
            report = contract[3]
            for name in findings:
                if not report.get(name):
                    continue
                addresses = []
                for address in report[name].split():
                    address = address.lower()
                    i = 2 if address[:2] == "0x" else 0
                    while i < len(address):
                        if address[i] not in "0123456789abcdef":
                            break
                        i += 1
                    try:
                        addresses.append(int(address[0:i], 16))
                    except ValueError:
                        pass
                if addresses:
                    for address in addresses:
                        findings_list.append(
                            {"filename": filename, "name": name, "address": address}
                        )
                else:
                    findings_list.append({"filename": filename, "name": name})

    except Exception as e:
        fails.add(f"problem extracting results.json from docker container: {e}")

    return findings_list, infos, errors, fails
