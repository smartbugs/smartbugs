import json
import src.output_parser.Parser as Parser
from sarif_om import *
from src.execution.execution_task import Execution_Task
from src.output_parser.SarifHolder import isNotDuplicateRule, parseLogicalLocation, parseRule, parseResult, parseArtifact, isNotDuplicateLogicalLocation


class Mythril(Parser.Parser):
    NAME = "mythril"
    VERSION = "2022/07/19"

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if not output:
            if not self._fails:
                self._fails.add('output missing')
            return
        self._fails.update(Parser.exceptions(self._lines))
        if 'aborting analysis' in output:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')
        try:
            # there may be a valid json object in the last line even if there was an error
            self._analysis = json.loads(self._lines[-1])
        except:
            return
        if self._analysis is not None and 'issues' in self._analysis and self._analysis['issues'] is not None:
            for issue in self._analysis['issues']:
                self._findings.add(issue['title'])
        if self._analysis is not None and 'error' in self._analysis and self._analysis['error'] is not None:
            self._errors.add(self._analysis['error'].split('.')[0])


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
