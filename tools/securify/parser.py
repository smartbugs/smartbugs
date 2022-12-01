import json, io, tarfile
import sb.parse_utils

VERSION = "2022/11/17"

FINDINGS = {
    "DAO",
    "DAOConstantGas",
    "MissingInputValidation",
    "TODAmount",
    "TODReceiver",
    "TODTransfer",
    "UnhandledException",
    "UnrestrictedEtherFlow"
}

def parse(exit_code, log, output):
    findings, infos = set(), set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log, log_expected=False)
    if fails:
        errors.discard("EXIT_CODE_1")

    # We look for the output in the following places, in that order:
    # - log (=stdout+stderr)
    # - output:results/results.json
    # - output:results/live.json
    try:
        try:
            analysis = json.loads(log)
        except:
            with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:
                try:
                    jsn = tar.extractfile("results/results.json").read()
                    analysis = json.loads(jsn)
                except:
                    jsn = tar.extractfile("results/live.json").read()
                    analysis = json.loads(jsn)
    except Exception:
        analysis = {}

    if not analysis:
        infos.add("analysis incomplete")
    elif "patternResults" in analysis: # live.json
        if "finished" in analysis and not analysis["finished"]:
            infos.add("analysis incomplete")
        if "decompiled" in analysis and not analysis["decompiled"]:
            errors.add("decompilation error")
        for vuln,check in analysis["patternResults"].items():
            if not check["completed"]:
                infos.add("analysis incomplete")
            if check["hasViolations"]:
                findings.add(vuln)
    else: # log or result.json
        for contract,analysis in analysis.items():
            for vuln,check in analysis["results"].items():
                if check["violations"]:
                    findings.add(vuln)

    if "analysis incomplete" in infos and not fails:
        fails.add("execution failed")

    findings = [ { "name": vuln } for vuln in findings ]

    return findings, infos, errors, fails

