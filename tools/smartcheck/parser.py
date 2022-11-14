import sb.parse_utils

VERSION = "2022/11/14"

FINDINGS = set()

def extract_result_line(line):
    index_split = line.index(":")
    key = line[:index_split]
    value = line[index_split + 1:].strip()
    if value.isdigit():
        value = int(value)
    return (key, value)

def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), []
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    current_error = None
    for line in log:
        if "ruleId: " in line:
            if current_error is not None:
                analysis.append(current_error)
            current_error = {
                'name': line[line.index("ruleId: ") + 8:]
            }
        elif current_error is not None and ':' in line and ' :' not in line:
            (key, value) = extract_result_line(line)
            current_error[key] = value
    if current_error is not None:
        analysis.append(current_error)

    findings = { result["name"] for result in analysis }

    return findings, infos, errors, fails, analysis
