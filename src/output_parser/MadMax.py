import src.output_parser.Gigahorse as Gigahorse
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class MadMax(Gigahorse.Gigahorse):
    NAME = "madmax"
    VERSION = "2022/07/23"
    PORTFOLIO = {
        "OverflowLoopIterator",
        "UnboundedMassOp",
        "WalletGriefing"
    }

    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="MadMax", version="6e9a6e9", rules=rulesList,
                                         information_uri="https://github.com/nevillegrech/MadMax/",
                                         full_description=MultiformatMessageString(
                                             text="Madmax consists of a series of analyses and queries that find gas-focussed vulnerabilities in Ethereum smart contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run
