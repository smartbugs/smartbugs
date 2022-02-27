if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from src.output_parser.Oyente import Oyente
from sarif_om import *
from src.execution.execution_task import Execution_Task
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class Osiris(Oyente):

    def parseSarif(self, osiris_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in osiris_output_results["analysis"]:

            for result in analysis["errors"]:
                line = -1
                column = -1
                if "line" in result:
                    line = result["line"]
                if "column" in result:
                    column = result["column"]
                rule = parseRule(tool="osiris", vulnerability=result["message"])
                result = parseResult(tool="osiris", vulnerability=result["message"], level="warning",
                                     uri=file_path_in_repo, line=line, column=column)

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)
            name = ""
            if "name" in analysis:
                name = analysis["name"]
            logicalLocation = parseLogicalLocation(name=name)

            if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Osiris", version="1.0", rules=rulesList,
                                         information_uri="https://github.com/christoftorres/Osiris",
                                         full_description=MultiformatMessageString(
                                             text="Osiris is an analysis tool to detect integer bugs in Ethereum smart contracts. Osiris is based on Oyente.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Osiris)
