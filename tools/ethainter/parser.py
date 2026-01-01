from typing import Optional

import tools.gigahorse.parser as gigahorse


VERSION = gigahorse.VERSION

FINDINGS = {
    "TaintedStoreIndex",
    "TaintedSelfdestruct",
    "TaintedValueSend",
    "UncheckedTaintedStaticcall",
    "AccessibleSelfdestruct",
    "TaintedDelegatecall",
    "TaintedOwnerVariable",
}


def parse(
    exit_code: Optional[int], log: list[str], output: Optional[bytes]
) -> tuple[list[dict], set[str], set[str], set[str]]:
    return gigahorse.parse(exit_code, log, output, FINDINGS)
