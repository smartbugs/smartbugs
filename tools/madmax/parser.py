import tools.gigahorse.parser as gigahorse


VERSION = gigahorse.VERSION

FINDINGS = {"OverflowLoopIterator", "UnboundedMassOp", "WalletGriefing"}


def parse(
    exit_code: int, log: list[str], output: bytes
) -> tuple[list[dict], set[str], set[str], set[str]]:
    return gigahorse.parse(exit_code, log, output, FINDINGS)
