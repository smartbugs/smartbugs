from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, \
    parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class HoneyBadger(Parser):
    def __init__(self):
        pass

    def extract_result_line(self, line):
        line = line.replace("INFO:symExec:	 ", '')
        index_split = line.index(":")
        key = line[:index_split].lower().replace(' ', '_').replace('(', '').replace(')', '').strip()
        value = line[index_split + 1:].strip()
        if "True" == value:
            value = True
        elif "False" == value:
            value = False
        return (key, value)

    def parse(self, str_output):
        output = []
        current_contract = None
        lines = str_output.splitlines()
        for line in lines:
            if "INFO:root:Contract " in line:
                if current_contract is not None:
                    output.append(current_contract)
                current_contract = {
                    'errors': []
                }
                (file, contract_name, _) = line.replace("INFO:root:Contract ", '').split(':')
                current_contract['file'] = file
                current_contract['name'] = contract_name
            elif "INFO:symExec:	 " in line and '---' not in line and '======' not in line:
                current_error = None
                (key, value) = self.extract_result_line(line)
                if value:
                    current_error = key
            elif current_contract is not None and current_contract['file'] in line and line.index(
                    current_contract['file']) == 0:
                (file, classname, line, column) = line.split(':')
                current_contract['errors'].append({
                    'line': int(line),
                    'column': int(column),
                    'message': current_error
                })
        if current_contract is not None:
            output.append(current_contract)
        return output

    def parseSarif(self, honeybadger_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in honeybadger_output_results["analysis"]:
            for result in analysis["errors"]:
                rule = parseRule(tool="honeybadger", vulnerability=result["message"])
                result = parseResult(tool="honeybadger", vulnerability=result["message"], level="warning",
                                     uri=file_path_in_repo, line=result["line"], column=result["column"])

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

            logicalLocation = parseLogicalLocation(analysis["name"])

            if logicalLocation is not None and isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="HoneyBadger", version="1.8.16", rules=rulesList,
                                         information_uri="https://honeybadger.uni.lu/",
                                         full_description=MultiformatMessageString(
                                             text="An analysis tool to detect honeypots in Ethereum smart contracts")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run
