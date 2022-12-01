import re, ast
import sb.parse_utils

VERSION = "2022/11/11"
    
FINDINGS = {
    "delegatecall bug",
    "selfdestruct bug",
    "call bug"
}

FINDING = re.compile(".*pakala\.analyzer\[.*\] INFO Found (.* bug)\.")
COVERAGE = re.compile("Symbolic execution finished with coverage (.*).")
FINISHED = re.compile("Nothing to report.|======> Bug found! Need .* transactions. <======")
TRANSACTION = re.compile("Transaction [0-9]+, example solution:")

def is_relevant(line):
    return not (
        line.startswith("Analyzing contract at")
        or line.startswith("Starting symbolic execution step...")
        or line.startswith("Symbolic execution finished with coverage")
        or line.startswith("Outcomes: ")
    )

def parse(exit_code, log, output):
    findings, infos = [], set()
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)
    errors.discard("EXIT_CODE_1") # there will be an exception in fails anyway

    analysis_completed = False
    in_tx = False
    for line in log:
        if in_tx:
            if line:
                tx_dict += line
            else:
                in_tx = False
                tx = ast.literal_eval(tx_dict)
                if not "exploit" in finding:
                    finding["exploit"] = []
                finding["exploit"].append(tx)

        m = TRANSACTION.match(line)
        if m:
            in_tx = True
            tx_dict = ""
            continue

        m = FINDING.match(line)
        if m:
            finding = { "name": m[1] }
            findings.append(finding)
            continue

        if FINISHED.match(line):
            analysis_completed = True
    if log and not analysis_completed:
        infos.add("analysis incomplete")
        if not fails and not errors:
            fails.add("execution failed")

    return findings, infos, errors, fails
