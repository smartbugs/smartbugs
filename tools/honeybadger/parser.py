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
        "Straw man contract"
}

def parse(exit_code, log, output):
    return oyente.parse(exit_code, log, output)
