if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import *
from src.output_parser.Oyente import Oyente
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class HoneyBadger(Oyente):

    def parseSarif(self, honeybadger_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in honeybadger_output_results["analysis"]:
            for result in analysis["errors"]:
                rule = parseRule(tool="honeybadger", vulnerability=result["message"])
                result = parseResult(tool="honeybadger", vulnerability=result["message"], level="warning",
                                     uri=file_path_in_repo, line=result["line"], column=result["column"])

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

            logicalLocation = parseLogicalLocation(analysis["name"])

            if logicalLocation is not None and isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="HoneyBadger", version="1.8.16", rules=rulesList,
                                         information_uri="https://honeybadger.uni.lu/",
                                         full_description=MultiformatMessageString(
                                             text="An analysis tool to detect honeypots in Ethereum smart contracts")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(HoneyBadger)
