import re

import sb.parse_utils


VERSION = "2025/09/14"

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


REPORT = re.compile(
    r"""
    ^(?P<filename>[^:]*)
    :(?P<line>\d+)
    :(?P<column>\d+)
    :\s*(?P<message>.*?)
    \s*\[(?P<level>[^\[/\]]*)/
    (?P<name>[^\[/\]]*)\]$
""",
    re.VERBOSE,
)


def parse(
    exit_code: int, log: list[str], output: bytes
) -> tuple[list[dict], set[str], set[str], set[str]]:
    findings: list[dict] = []
    infos: set[str] = set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    errors.discard("EXIT_CODE_1")

    for line in log:
        match = REPORT.match(line)
        if match:
            finding = match.groupdict()
            finding["line"] = int(finding["line"])
            finding["column"] = int(finding["column"])
            finding["level"] = finding["level"].lower()
            findings.append(finding)

    return findings, infos, errors, fails
