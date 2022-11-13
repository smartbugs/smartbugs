import sb.parse_utils
import io, tarfile, json

VERSION = "2022/11/11"

def parse(exit_code, log, output, FINDINGS):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    if "Writing results to results.json" not in log:
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            results_json=tar.extractfile("results.json").read()
        result = json.loads(results_json)
        for contract in result:
            filename = contract[0]
            errors.update(contract[2])
            report = contract[3]
            for name in FINDINGS:
                for address in report.get(name).split():
                    findings.append({
                        "filename": filename,
                        "name": name,
                        "address": int(address,16)
                    })
    except Exception as e:
        fails.add("problem extracting results.json from docker container")

    return findings, infos, errors, fails
