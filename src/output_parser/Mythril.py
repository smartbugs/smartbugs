from sarif_om import *
import json

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseLogicalLocation, parseRule, \
    parseResult, parseArtifact, isNotDuplicateLogicalLocation


class Mythril(Parser):

    def __init__(self, task: 'Execution_Task', str_output: str):
        Parser.__init__(self, task, str_output)
        # success depends also whether json succeeds, so we
        # do everything at once.
        self.success = False
        self.result = None
        if str_output is not None:
            lines = str_output.split('\n')
            try:
                # there may be a valid json in the last line even if there was an error
                self.result = json.loads(lines[-1])
            except:
                return
            # there was a valid json, but there may have been an error, too
            self.success = 'aborting analysis' not in str_output and 'Traceback' not in str_output

    def is_success(self) -> bool:
        return self.success

    def parse(self):
        return self.result

    def parseSarif(self, mythril_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for issue in mythril_output_results["analysis"]["issues"]:
            level = issue["severity"] if "severity" in issue else issue["type"]
            rule = parseRule(tool="mythril", vulnerability=issue["title"], full_description=issue["description"])
            result = parseResult(tool="mythril", vulnerability=issue["title"], level=level,
                                 uri=file_path_in_repo,
                                 line=issue["lineno"], snippet=issue["code"] if "code" in issue.keys() else None,
                                 logicalLocation=parseLogicalLocation(issue["function"],
                                                                      kind="function"))

            logicalLocation = parseLogicalLocation(name=issue["function"], kind="function")

            if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)
            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Mythril", version="0.4.25", rules=rulesList,
                                         information_uri="https://mythx.io/",
                                         full_description=MultiformatMessageString(
                                             text="Mythril analyses EVM bytecode using symbolic analysis, taint analysis and control flow checking to detect a variety of security vulnerabilities.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run
