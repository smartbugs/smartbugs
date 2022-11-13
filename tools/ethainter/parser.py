import tools.gigahorse.parser as gigahorse

VERSION = gigahorse.VERSION

FINDINGS = {
    "TaintedStoreIndex",
    "TaintedSelfdestruct",
    "TaintedValueSend",
    "UncheckedTaintedStaticcall",
    "AccessibleSelfdestruct",
    "TaintedDelegatecall",
    "TaintedOwnerVariable"
}

def parse(exit_code, log, output):
    return gigahorse.parse(exit_code, log, output, FINDINGS)
