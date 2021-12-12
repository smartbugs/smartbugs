from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class Conkas(Parser):

    def __init__(self, task: 'Execution_Task', str_output: str):
        super().__init__(task, str_output)
        if str_output is None:
            return
        self.output = []
        lines = str_output.splitlines()
        for line in lines:
            if 'Vulnerability: ' in line:
                self.output.append(Conkas.__parse_vuln_line(line))
        self.labels = sorted({issue['vuln_type'] for issue in self.output})
        self.success = 'Traceback' not in str_output

    @staticmethod
    def __parse_vuln_line(line: str):
        vuln_type = line.split('Vulnerability: ')[1].split('.')[0]
        maybe_in_function = line.split('Maybe in function: ')[1].split('.')[0]
        pc = line.split('PC: ')[1].split('.')[0]
        line_number = line.split('Line number: ')[1].split('.')[0]
        return {
            'vuln_type': Parser.str2label(vuln_type),
            'maybe_in_function': maybe_in_function,
            'pc': pc,
            'line_number': line_number
        }
    
    def parseSarif(self, conkas_output_results, file_path_in_repo):
        # conkas_output_results obsolete, kept for compatibility
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in self.output:
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
