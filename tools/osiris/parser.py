import tools.oyente.parser as oyente

VERSION = "2022/08/06"

FINDINGS = {
    "Arithmetic bugs",
    "Overflow bugs",
    "Underflow bugs",
    "Division bugs",
    "Modulo bugs",
    "Truncation bugs",
    "Signedness bugs",
    "Callstack bug",
    "Concurrency bug",
    "Timedependency bug",
    "Reentrancy bug",
}

def parse(exit_code, log, output, task):
    return oyente.parse(exit_code, log, output, task, FINDINGS)
