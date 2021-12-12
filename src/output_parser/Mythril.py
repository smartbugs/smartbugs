from sarif_om import *
import json

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseLogicalLocation, parseRule, \
    parseResult, parseArtifact, isNotDuplicateLogicalLocation


class Mythril(Parser):

    def __init__(self, task: 'Execution_Task', str_output: str):
        super().__init__(task, str_output)
        if str_output is None:
            return
        lines = str_output.splitlines()
        try:
            # there may be a valid json in the last line even if there was an error
            self.output = json.loads(lines[-1])
        except:
            return
        if self.output is not None and 'issues' in self.output and self.output['issues'] is not None:
            labels = set()
            for issue in self.output['issues']:
                labels.add(Parser.str2label(issue['title']))
            self.labels = sorted(labels)
        # there was a valid json, but there may have been an error, too
        self.success = 'aborting analysis' not in str_output and 'Traceback' not in str_output

    def parseSarif(self, mythril_output_results, file_path_in_repo):
        # mythril_output_results obsolete, kept for compatibility
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for issue in self.output["issues"]:
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
