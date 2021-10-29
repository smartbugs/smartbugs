from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class TeEther(Parser):

    def is_success(self):
        return "Traceback" not in self.str_output

    def parse(self):
        output = {
            'exploit': []
        }
        str_output = self.str_output.split('\n')

        for line in str_output:
            if "sendTransaction" in line:
                output['exploit'].append(line)

        return [output]
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="TeEther", version="04adf56", rules=rulesList,
                                         information_uri="https://github.com/nescio007/teether",
                                         full_description=MultiformatMessageString(
                                             text="TeEther consists of a series of analyses and queries that find gas-focussed vulnerabilities in Ethereum smart contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run