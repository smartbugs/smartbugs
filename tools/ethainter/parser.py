import sb.parse_utils
import io, tarfile, json

VERSION = "2022/08/05"

FINDINGS = {
    "TaintedStoreIndex",
    "TaintedSelfdestruct",
    "TaintedValueSend",
    "UncheckedTaintedStaticcall",
    "AccessibleSelfdestruct",
    "TaintedDelegatecall",
    "TaintedOwnerVariable"
}


def parse(exit_code, log, output, task, FINDINGS=FINDINGS):
    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if "Writing results to results.json" not in log:
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            results_json=tar.extractfile("results.json").read()
        analysis = json.loads(results_json)
        for contract in analysis:
            errors.update(contract[2])
            results = contract[3]
            for finding in FINDINGS:
                if results.get(finding):
                    findings.add(finding)
    except Exception as e:
        fails.add("problem extracting results.json from docker container")

    return findings, infos, errors, fails, analysis
