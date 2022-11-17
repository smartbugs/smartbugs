import tools.oyente.parser as oyente

VERSION = oyente.VERSION

FINDINGS = {
#    "Arithmetic bugs", # redundant, a sub-category will be reported anyway
    "Overflow bugs",
    "Underflow bugs",
    "Division bugs",
    "Modulo bugs",
    "Truncation bugs",
    "Signedness bugs",
    "Callstack bug",
    "Concurrency bug",
    "Timedependency bug",
    "Time dependency bug",
    "Reentrancy bug",
}

def parse(exit_code, log, output):
    return oyente.parse(exit_code, log, output)
