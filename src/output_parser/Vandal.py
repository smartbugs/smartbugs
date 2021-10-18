from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class Vandal(Parser):
    def __init__(self):
        pass

    @staticmethod
    def __parse_vuln_line(line):
        if 'checkedCallStateUpdate.csv' in line:
            vuln_type = 'CheckedCallStateUpdate'
        elif 'destroyable.csv' in line:
            vuln_type = 'Destroyable'
        elif 'originUsed.csv' in line:
            vuln_type = 'OriginUsed'
        elif 'reentrantCall.csv' in line:
            vuln_type = 'ReentrantCall'
        elif 'unsecuredValueSend.csv' in line:
            vuln_type = 'UnsecuredValueSend'
        elif 'uncheckedCall.csv' in line:
            vuln_type = 'UncheckedCall'
        return {
            'vuln_type': vuln_type
        }

    def parse(self, str_output):
        output = []
        str_output = str_output.split('\n')
        for line in str_output:
            if '.csv' in line:
                try:
                    output.append(self.__parse_vuln_line(line))
                except:
                    continue
        return output

    ## TODO: Sarif
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
