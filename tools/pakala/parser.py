import re
import sb.parse_utils

VERSION = "2022/08/06"
    
FINDINGS = {
    "delegatecall bug",
    "selfdestruct bug",
    "call bug"
}

FINDING = re.compile('.*pakala\.analyzer\[.*\] INFO Found (.* bug)\.')
COVERAGE = re.compile('Symbolic execution finished with coverage (.*).')
FINISHED = re.compile('Nothing to report.|======> Bug found! Need .* transactions. <======')

def is_relevant(line):
    return not (
        line.startswith("Analyzing contract at")
        or line.startswith("Starting symbolic execution step...")
        or line.startswith("Symbolic execution finished with coverage")
        or line.startswith("Outcomes: ")
    )

def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), None
    cleaned_log = filter(is_relevant, log)
    errors, fails = sb.parse_utils.errors_fails(exit_code, cleaned_log)
    errors.discard('EXIT_CODE_1') # there will be an exception in fails anyway

    coverage = None
    analysis_completed = False
    traceback = False
    for line in log:
        m = COVERAGE.match(line)
        if m:
            coverage = m[1]
        m = FINDING.match(line)
        if m:
            findings.add(m[1])
        if FINISHED.match(line):
            analysis_completed = True
    if log and not analysis_completed:
        infos.add('analysis incomplete')
        if not fails and not errors:
            fails.add('execution failed')

    analysis = { 'vulnerabilities': sorted(findings) }
    if coverage:
        analysis['coverage'] = coverage
    analysis = [ analysis ]

    return findings, infos, errors, fails, analysis
