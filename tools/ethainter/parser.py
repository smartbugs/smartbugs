import tools.gigahorse.parser as gigahorse

VERSION = "2022/08/05"

FINDINGS = {
    "TaintedStoreIndex",
    "TaintedSelfdestruct",
    "TaintedValueSend",
    "UncheckedTaintedStaticcall",
    "AccessibleSelfdestruct",
    "TaintedDelegatecall",
    "TaintedOwnerVariable"
}

def parse(exit_code, log, output, task):
    return gigahorse.parse(exit_code, log, output, task, FINDINGS)
