from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class EasyFlow(Parser):

    def is_success(self):
        return "Traceback" not in self.str_output

    def parse(self):
        output = {
            'errors': []
        }
        str_output = self.str_output.split('\n')

        for line in str_output:
            if "input:" in line:
                output['input'] = line.split('input:')[1].strip()
            if "result:" in line:
                output['result'] = line.split('result:')[1].strip()
            if "Coverage" in line:
                output['coverage'] = line.split('Coverage:')[1].strip()

        return [output]
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="EasyFlow", version="c7a34b6", rules=rulesList,
                                         information_uri="https://github.com/Jianbo-Gao/EasyFlow/",
                                         full_description=MultiformatMessageString(
                                             text="EasyFlow is a prototype of overflow detection tool for Ethereum smart contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run