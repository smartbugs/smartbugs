import io
import json
import os
import re
import tarfile

import sb.parse_utils

VERSION = "2023/03/02"

FINDINGS = {
    "Block Number Dependency",
    "Dangerous Delegate Call",
    "Exception Disorder",
    "Freezing Ether",
    "Gasless Send",
    "Integer Overflow",
    "Integer Underflow",
    "Reentrancy",
    "Timestamp Dependency"
}

STATS_FILENAME = "stats.csv"


def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if output:
        try:
            # file structure:
            # stats: contracts/<contract_name>.sol:<contract_name>/stats.csv
            # vulnerabilities: contracts/<contract_name>.sol:<contract_name>/<finding_name>.json
            with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
                for member in tar.getmembers():
                    if member.name.endswith(STATS_FILENAME):
                        stats = tar.extractfile(member)
                        vs = vulnerabilities(stats)
                        for (name, filename) in vs.items():
                            v_member = tar.getmember(member.name.replace(STATS_FILENAME, filename))
                            v_json = json.load(tar.extractfile(v_member))
                            for function in v_json["functions"]:
                                finding = {
                                    "contract": member.name.split(os.path.sep)[1].split(":")[0],
                                    "name": name,
                                    "function": function["name"]
                                }
                                findings.append(finding)
        except Exception as e:
            print(e)
            fails.add(f"error parsing results: {e}")

    return findings, infos, errors, fails


def vulnerabilities(stats):
    vs = {}

    # Skip to last line
    line = ""
    for line in stats:
        pass
    if line == "":
        return vs
    last = re.sub('[\'b\\n]', '', line.decode("utf-8"))
    results = list(map(float, last.split(",")))

    # Parse found vulnerabilities
    if len(results) != 53:
        return vs

    if results[-1] >= 1:
        vs["Integer Underflow"] = "integer_underflow.json"
    if results[-2] >= 1:
        vs["Integer Overflow"] = "integer_overflow.json"
    if results[-9] >= 1:
        vs["Freezing Ether"] = "freezing_ether.json"
    if results[-10] >= 1:
        vs["Dangerous Delegate Call"] = "dangerous_delegatecall.json"
    if results[-11] >= 1:
        vs["Block Number Dependency"] = "block_number_dependency.json"
    if results[-12] >= 1:
        vs["Timestamp Dependency"] = "timestamp_dependency.json"
    if results[-13] >= 1:
        vs["Reentrancy"] = "reentrancy.json"
    if results[-14] >= 1:
        vs["Exception Disorder"] = "exception_disorder.json"
    if results[-15] >= 1:
        vs["Gasless Send"] = "gasless_send.json"

    return vs
