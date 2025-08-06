import sb.parse_utils

VERSION = "2025/08/06"

FINDINGS = {
    "avoid-call-value",
    "avoid-low-level-calls",
    "avoid-sha3",
    "avoid-suicide",
    "avoid-throw",
    "avoid-tx-origin",
    "check-send-result",
    "code-complexity",
    "compiler-version",
    "comprehensive-interface",
    "const-name-snakecase",
    "constructor-syntax",
    "contract-name-capwords",
    "duplicated-imports",
    "event-name-capwords",
    "explicit-types",
    "foundry-test-functions",
    "func-named-parameters",
    "func-name-mixedcase",
    "func-param-name-mixedcase",
    "function-max-lines",
    "func-visibility",
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
    "not-rely-on-block-hash",
    "not-rely-on-time",
    "no-unused-import",
    "no-unused-vars",
    "one-contract-per-file",
    "ordering",
    "payable-fallback",
    "private-vars-leading-underscore",
    "quotes",
    "reason-string",
    "reentrancy",
    "state-visibility",
    "use-forbidden-name",
    "use-natspec",
    "var-name-mixedcase",
    "visibility-modifier-order",
}

def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard("EXIT_CODE_1")

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
