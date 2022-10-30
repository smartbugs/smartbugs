import sb.parse_utils

VERSION = "2022/10/30"

FINDINGS = set()

def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), []
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    for line in log:
        if ":" in line:
            s_result = line.split(':')
            if len(s_result) != 4:
                continue
            (file, line, column, end_error) = s_result
            if ']' not in end_error:
                continue
            message = end_error[1:end_error.index('[') - 1]
            level = end_error[end_error.index('[') + 1: end_error.index('/')]
            type = end_error[end_error.index('/') + 1: len(end_error) - 1]
            analysis.append({
                'file': file,
                'line': line,
                'column': column,
                'message': message,
                'level': level,
                'type': type
            })
            findings.add(type)

    return findings, infos, errors, fails, analysis
