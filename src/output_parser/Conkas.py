if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import re
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser, python_errors
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation
from src.execution.execution_task import Execution_Task

ERRORS = (
        ('PHI instruction need arguments but ', 'PHI error'),
        ('solcx.exceptions.SolcError:', 'solc error'),
        ('CREATE2 instruction needs ', 'CREATE2 error'),
        ('JUMPDEST instruction should not be reached', 'JUMPDEST error'),
        ('PUSH instruction needs ', 'PUSH error'),
)


class Conkas(Parser):

    @staticmethod
    def __parse_vuln(line: str):
        vuln_type = line.split('Vulnerability: ')[1].split('.')[0]
        maybe_in_function = line.split('Maybe in function: ')[1].split('.')[0]
        pc = line.split('PC: ')[1].split('.')[0]
        line_number = line.split('Line number: ')[1].split('.')[0]
        return {
            'vuln_type': vuln_type,
            'maybe_in_function': maybe_in_function,
            'pc': pc,
            'line_number': line_number
        }

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(re.sub('Analysing .*\.\.\.\n','',output)))
        for indicator,error in ERRORS:
            if indicator in output:
                self._errors.add(error)
        self._analysis = []
        for line in self._lines:
            if 'Vulnerability: ' in line:
                issue = Conkas.__parse_vuln(line)
                self._analysis.append(issue)
                self._findings.add(issue['vuln_type'])
    
    def parseSarif(self, conkas_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in conkas_output_results["analysis"]:
            rule = parseRule(tool="conkas", vulnerability=analysis_result["vuln_type"])

            logicalLocation = parseLogicalLocation(analysis_result["maybe_in_function"], kind="function")

            line = int(analysis_result["line_number"]) if analysis_result["line_number"] != "" else -1

            result = parseResult(tool="conkas", vulnerability=analysis_result["vuln_type"], uri=file_path_in_repo,
                                 line=line,
                                 logicalLocation=logicalLocation)

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Conkas", version="1.0.0", rules=rulesList,
                                         information_uri="https://github.com/nveloso/conkas",
                                         full_description=MultiformatMessageString(
                                             text="Conkas is based on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Conkas uses rattle to lift bytecode to a high level representation.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Conkas)

