import sb.parse_utils

VERSION = "2023/02/12"

FINDINGS = {
    "array-declaration-spaces",
    "avoid-call-value",
    "avoid-low-level-calls",
    "avoid-sha3",
    "avoid-suicide",
    "avoid-throw",
    "avoid-tx-origin",
    "bracket-align",
    "check-send-result",
    "code-complexity",
    "compiler-fixed",
    "compiler-gt-0_4",
    "compiler-version",
    "comprehensive-interface",
    "const-name-snakecase",
    "constructor-syntax",
    "contract-name-camelcase",
    "event-name-camelcase",
    "expression-indent",
    "func-name-mixedcase",
    "func-order",
    "func-param-name-mixedcase",
    "function-max-lines",
    "func-visibility",
    "imports-on-top",
    "indent",
    "mark-callable-contracts",
    "max-line-length",
    "max-states-count",
    "modifier-name-mixedcase",
    "multiple-sends",
    "no-complex-fallback",
    "no-console",
    "no-empty-blocks",
    "no-global-import",
    "no-inline-assembly",
    "no-mix-tabs-and-spaces",
    "no-simple-event-func-name",
    "no-spaces-before-semicolon",
    "not-rely-on-block-hash",
    "not-rely-on-time",
    "no-unused-vars",
    "ordering",
    "payable-fallback",
    "private-vars-leading-underscore",
    "quotes",
    "reason-string",
    "reentrancy",
    "separate-by-one-line-in-contract",
    "space-after-comma",
    "statement-indent",
    "state-visibility",
    "two-lines-top-level-separator",
    "use-forbidden-name",
    "var-name-mixedcase",
    "visibility-modifier-order",
}

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)

    for line in log:
        if ":" in line:
            s_result = line.split(":")
            if len(s_result) != 4:
                continue
            (file, lineno, column, end_error) = s_result
            if "]" not in end_error:
                continue
            message = end_error[1:end_error.index("[") - 1]
            level = end_error[end_error.index("[") + 1: end_error.index("/")]
            name = end_error[end_error.index("/") + 1: len(end_error) - 1]
            findings.append({
                "filename": file,
                "line": int(lineno),
                "column": int(column),
                "message": message,
                "level": level.lower(),
                "name": name
            })

    return findings, infos, errors, fails
