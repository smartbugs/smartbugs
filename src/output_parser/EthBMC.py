from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class EthBMC(Parser):

    def is_success(self):
        return "Finished analysis" in self.str_output

    def parse(self):
        output = {
            'exploit': []
        }
        str_output = self.str_output.split('\n')

        for line in str_output:
            if "Code covered: " in line:
                output['coverage'] = line.split("Code covered: ")[1]
            if "Found attack, " in line:
                output['exploit'].append(line.split("Found attack, ")[1])

        return [output]
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="EthBMC", version="60d1b58", rules=rulesList,
                                         information_uri="https://github.com/RUB-SysSec/EthBMC",
                                         full_description=MultiformatMessageString(
                                             text="A Bounded Model Checker for Smart Contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run