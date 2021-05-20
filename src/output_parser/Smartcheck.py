from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseArtifact, parseRule, parseResult, parseLogicalLocation


class Smartcheck(Parser):
    def __init__(self):
        pass

    def extract_result_line(self, line):
        index_split = line.index(":")
        key = line[:index_split]
        value = line[index_split + 1:].strip()
        if value.isdigit():
            value = int(value)
        return (key, value)

    def parse(self, str_output):
        output = []
        current_error = None
        lines = str_output.splitlines()
        for line in lines:
            if "ruleId: " in line:
                if current_error is not None:
                    output.append(current_error)
                current_error = {
                    'name': line[line.index("ruleId: ") + 8:]
                }
            elif current_error is not None and ':' in line and ' :' not in line:
                (key, value) = self.extract_result_line(line)
                current_error[key] = value

        if current_error is not None:
            output.append(current_error)
        return output

    def parseSarif(self, smartcheck_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        for analysis in smartcheck_output_results["analysis"]:
            rule = parseRule(tool="smartcheck", vulnerability=analysis["name"])
            result = parseResult(tool="smartcheck", vulnerability=analysis["name"], level=analysis["severity"],
                                 uri=file_path_in_repo,
                                 line=analysis["line"], column=analysis["column"], snippet=analysis["content"])

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

        logicalLocation = parseLogicalLocation(name=smartcheck_output_results["contract"])

        tool = Tool(driver=ToolComponent(name="SmartCheck", version="0.0.12", rules=rulesList,
                                         information_uri="https://tool.smartdec.net/",
                                         full_description=MultiformatMessageString(
                                             text="Securify automatically checks for vulnerabilities and bad coding practices. It runs lexical and syntactical analysis on Solidity source code.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=[logicalLocation], results=resultsList)

        return run
