import re
from collections.abc import Iterator

import sb.cfg  # for sb.parse_utils.init(...)
import sb.parse_utils


VERSION: str = "2025/08/06"

FINDINGS = [
    "accessible-selfdestruct",
    "arbitrary-low-level-call",
    "array-length-outside-loop",
    "bad-transferfrom-access-control",
    "balancer-readonly-reentrancy-getpooltokens",
    "balancer-readonly-reentrancy-getrate",
    "basic-arithmetic-underflow",
    "basic-oracle-manipulation",
    "compound-borrowfresh-reentrancy",
    "compound-precision-loss",
    "compound-sweeptoken-not-restricted",
    "curve-readonly-reentrancy",
    "delegatecall-to-arbitrary-address",
    "encode-packed-collision",
    "erc20-public-burn",
    "erc20-public-transfer",
    "erc677-reentrancy",
    "erc721-arbitrary-transferfrom",
    "erc721-reentrancy",
    "erc777-reentrancy",
    "exact-balance-check",
    "gearbox-tokens-path-confusion",
    "incorrect-use-of-blockhash",
    "inefficient-state-variable-increment",
    "init-variables-with-default-value",
    "keeper-network-oracle-manipulation",
    "missing-assignment",
    "msg-value-multicall",
    "no-bidi-characters",
    "non-optimal-variables-swap",
    "non-payable-constructor",
    "no-slippage-check",
    "olympus-dao-staking-incorrect-call-order",
    "openzeppelin-ecdsa-recover-malleable",
    "oracle-price-update-not-restricted",
    "oracle-uses-curve-spot-price",
    "proxy-storage-collision",
    "public-transfer-fees-supporting-tax-tokens",
    "redacted-cartel-custom-approval-bug",
    "rigoblock-missing-access-control",
    "sense-missing-oracle-access-control",
    "state-variable-read-in-a-loop",
    "superfluid-ctx-injection",
    "tecra-coin-burnfrom-bug",
    "thirdweb-vulnerability",
    "uniswap-callback-not-protected",
    "uniswap-v4-callback-not-protected",
    "unnecessary-checked-arithmetic-in-loop",
    "unrestricted-transferownership",
    "use-abi-encodecall-instead-of-encodewithselector",
    "use-custom-error-not-require",
    "use-multiple-require",
    "use-nested-if",
    "use-ownable2step",
    "use-prefix-decrement-not-postfix",
    "use-prefix-increment-not-postfix",
    "use-short-revert-string",
]


def message_lines(log_iterator: Iterator[str]) -> str:
    msg_lines: list[str] = []
    while True:
        next_line = next(log_iterator, "").strip()
        if not next_line:
            break
        msg_lines.append(next_line)
    return " ".join(msg_lines)


def parse(
    exit_code: int, log: list[str], output: bytes
) -> tuple[list[dict], set[str], set[str], set[str]]:

    findings: list[dict] = []
    infos: set[str] = set()
    finding: dict = {}
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    log_iterator = iter(log)

    for line in log_iterator:

        line = line.strip()

        # if line.startswith('/'):
        #     filename = line.split("/")
        #     filename = '/'.join(filename[-2:])
        #     finding = {'filename': filename}

        if re.search(r"solidity\.(performance|best-practice|security)\.", line):
            match = re.search(r"solidity\.(performance|best-practice|security)\.(\S+)", line)
            category = match.group(1)
            name = match.group(2)
            finding["name"] = name
            finding["category"] = category
            finding["message"] = message_lines(log_iterator)

        elif re.search(r"\d+┆", line):
            line_location = line.strip().split("┆", 1)
            if len(line_location) > 0:
                cline_number = int(line_location[0])
                finding["line"] = cline_number

            findings.append(finding.copy())

    return findings, infos, errors, fails
