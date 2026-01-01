from typing import Optional

import tools.oyente.parser as oyente


VERSION = oyente.VERSION

FINDINGS = {
    "Money flow",
    "Balance disorder",
    "Hidden transfer",
    "Inheritance disorder",
    "Uninitialised struct",
    "Type overflow",
    "Skip empty string",
    "Hidden state update",
    "Straw man contract",
}


def parse(
    exit_code: Optional[int], log: list[str], output: Optional[bytes]
) -> tuple[list[dict], set[str], set[str], set[str]]:
    return oyente.parse(exit_code, log, output)
