from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class Conkas(Parser):
    def __init__(self):
        pass

    @staticmethod
    def __parse_vuln_line(line):
        vuln_type = line.split('Vulnerability: ')[1].split('.')[0]
        maybe_in_function = line.split('Maybe in function: ')[1].split('.')[0]
        pc = line.split('PC: ')[1].split('.')[0]
        line_number = line.split('Line number: ')[1].split('.')[0]
        if vuln_type == 'Integer Overflow':
            vuln_type = 'Integer_Overflow'
        elif vuln_type == 'Integer Underflow':
            vuln_type = 'Integer_Underflow'
        return {
            'vuln_type': vuln_type,
            'maybe_in_function': maybe_in_function,
            'pc': pc,
            'line_number': line_number
        }

    def parse(self, str_output):
        output = []
        str_output = str_output.split('\n')
        for line in str_output:
            if 'Vulnerability' in line:
                try:
                    output.append(self.__parse_vuln_line(line))
                except:
                    continue
        return output

    def parseSarif(self, conkas_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in conkas_output_results["analysis"]:
            rule = parseRule(tool="conkas", vulnerability=analysis_result["vuln_type"])

            logicalLocation = parseLogicalLocation(analysis_result["maybe_in_function"], kind="function")

            result = parseResult(tool="conkas", vulnerability=analysis_result["vuln_type"], uri=file_path_in_repo,
                                 line=int(analysis_result["line_number"]),
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
