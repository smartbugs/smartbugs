if __name__ == '__main__':
    import sys
    sys.path.append("../..")

import re

from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser, python_errors
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


FINDINGS = (
    ('checkedCallStateUpdate.csv', 'CheckedCallStateUpdate'),
    ('destroyable.csv', 'Destroyable'),
    ('originUsed.csv',  'OriginUsed'),
    ('reentrantCall.csv', 'ReentrantCall'),
    ('unsecuredValueSend.csv', 'UnsecuredValueSend'),
    ('uncheckedCall.csv', 'UncheckedCall')
)

ANALYSIS_COMPLETE = re.compile(
    f".*{re.escape('+ /vandal/bin/decompile')}"
    f".*{re.escape('+ souffle -F facts-tmp')}"
    f".*{re.escape('+ rm -rf facts-tmp')}",
    re.DOTALL)

ERRORS = (
    ('Error loading data: Cannot open fact file', 'internal error'),
    ('Killed', 'exception occurred'),
)

class Vandal(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(output))
        if not ANALYSIS_COMPLETE.match(output):
            self._errors.add('analysis incomplete')
        for indicator,error in ERRORS:
            if indicator in output:
                self._errors.add(error)
        for indicator,finding in FINDINGS:
            if indicator in output:
                self._findings.add(finding)
        self._analysis = sorted(self._findings)


    ## TODO: Sarif
    def parseSarif(self, conkas_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in conkas_output_results["analysis"]:
            for error in analysis_result['errors']:
                rule = parseRule(
                    tool="conkas", vulnerability=error["vuln_type"])

                function_name = error["maybe_in_function"] if "maybe_in_function" in error else ""
                logical_location = parseLogicalLocation(
                    function_name, kind="function")

                line_number = int(error["line_number"]
                                  ) if "line_number" in error else -1

                result = parseResult(tool="conkas", vulnerability=error["vuln_type"], uri=file_path_in_repo,
                                     line=line_number,
                                     logicalLocation=logical_location)

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

                if isNotDuplicateLogicalLocation(logical_location, logicalLocationsList):
                    logicalLocationsList.append(logical_location)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Conkas", version="1.0.0", rules=rulesList,
                                         information_uri="https://github.com/nveloso/conkas",
                                         full_description=MultiformatMessageString(
                                             text="Conkas is based on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Conkas uses rattle to lift bytecode to a high level representation.")))

        run = Run(tool=tool, artifacts=[
                  artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Vandal)

