import tools.gigahorse.parser as gigahorse

VERSION = gigahorse.VERSION

FINDINGS = {
    "OverflowLoopIterator",
    "UnboundedMassOp",
    "WalletGriefing"
}

def parse(exit_code, log, output):
    return gigahorse.parse(exit_code, log, output, FINDINGS)
