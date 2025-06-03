import sb.parse_utils

VERSION = "2023/02/12"

FINDINGS = {
    "avoid-call-value",
    "avoid-low-level-calls",
    "avoid-sha3",
    "avoid-suicide",
    "avoid-throw",
    "avoid-tx-origin",
    "check-send-result",
    "code-complexity",
    "comprehensive-interface",
    "compiler-version",
    "constructor-syntax",
    "const-name-snakecase",
    "contract-name-camelcase",
    "contract-name-capwords",
    "duplicated-imports",
    "event-name-camelcase",
    "event-name-capwords",
    "event-name-pascalcase",
    "explicit-types",
    "func-name-mixedcase",
    "func-named-parameters",
    "func-order",
    "func-param-name-mixedcase",
    "func-visibility",
    "function-max-lines",
    "foundry-test-functions",
    "gas-calldata-parameters",
    "gas-custom-errors",
    "gas-increment-by-one",
    "gas-indexed-events",
    "gas-length-in-loops",
    "gas-multitoken1155",
    "gas-named-return-values",
    "gas-small-strings",
    "gas-strict-inequalities",
    "gas-struct-packing",
    "immutable-vars-naming",
    "import-path-check",
    "imports-on-top",
    "imports-order",
    "interface-starts-with-i",
    "max-line-length",
    "max-states-count",
    "modifier-name-mixedcase",
    "multiple-sends",
    "named-parameters-mapping",
    "no-complex-fallback",
    "no-console",
    "no-empty-blocks",
    "no-global-import",
    "no-inline-assembly",
    "no-unused-import",
    "no-unused-vars",
    "not-rely-on-block-hash",
    "not-rely-on-time",
    "one-contract-per-file",
    "ordering",
    "payable-fallback",
    "private-vars-leading-underscore",
    "quotes",
    "reason-string",
    "reentrancy",
    "state-visibility",
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
