import io, tarfile, json
import sb.parse_utils

VERSION = "2022/10/30"

FINDINGS = set()

def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    #for line in log:
    #    pass

    try:
        with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
            output_json = tar.extractfile("output.json").read()
            analysis = json.loads(output_json)
            findings = { finding["check"] for finding in analysis }
    except Exception as e:
        fails.add(f"error parsing results: {e}")

    return findings, infos, errors, fails, analysis
