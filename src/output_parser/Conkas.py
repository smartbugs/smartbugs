import re
import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation
from src.execution.execution_task import Execution_Task


ERRORS = (
    re.compile("([A-Z0-9]+ instruction needs return value)"),
    re.compile("([A-Z0-9]+ instruction needs [0-9]+ arguments but [0-9]+ was given)"),
    re.compile("([A-Z0-9]+ instruction need arguments but [0-9]+ was given)"),
    re.compile("([A-Z0-9]+ instruction needs a concrete argument)"),
    re.compile("([A-Z0-9]+ instruction should not be reached)"),
    re.compile("([A-Z0-9]+ instruction is not implemented)"),
    re.compile("(Cannot get source map runtime\. Check if solc is in your path environment variable)"),
    re.compile("(Vulnerability module checker initialized without traces)"),
    re.compile(".*(solcx.exceptions.SolcError:.*)")
)

class Conkas(Parser.Parser):
    NAME = "conkas"
    VERSION = "2022/07/23"
    PORTFOLIO = {
        "Integer Overflow",
        "Integer Underflow",
        "Reentrancy",
        "Time Manipulation",
        "Transaction Ordering Dependence",
        "Unchecked Low Level Call"
    }

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

    @staticmethod
    def __skip(line):
        return line.startswith("Analysing ") and line.endswith("...")

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)

        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return
        # removing spurious 'Analysing' message disrupting exception traces
        self._fails.update(Parser.exceptions(self._lines, Conkas.__skip))
        self._analysis = []
        for line in self._lines:
            if Parser.add_match(self._errors, line, ERRORS):
                self._fails.discard('exception (Exception)')
                continue
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
