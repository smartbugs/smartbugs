from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class Vandal(Parser):

    @staticmethod
    def __parse_vuln_line(line: str):
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

    def parse(self):
        output = {
            "errors": []
        }
        str_output = self.str_output.split('\n')
        for line in str_output:
            if '.csv' in line:
                try:
                    output['errors'].append(self.__parse_vuln_line(line))
                except:
                    continue
        return [output]

    def is_success(self):
        return "+ rm -rf facts-tmp" in "\n".join(self.str_output.split("\n")[4:])

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
