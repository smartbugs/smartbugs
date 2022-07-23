import src.output_parser.Gigahorse as Gigahorse

class Ethainter(Gigahorse.Gigahorse):
    NAME = "ethainter"
    VERSION = "2022/07/23"
    PORTFOLIO = {
        "TaintedStoreIndex",
        "TaintedSelfdestruct",
        "TaintedValueSend",
        "UncheckedTaintedStaticcall",
        "AccessibleSelfdestruct",
        "TaintedDelegatecall",
        "TaintedOwnerVariable"
    }

    def parseSarif(self, output_results, file_path_in_repo):
        pass
