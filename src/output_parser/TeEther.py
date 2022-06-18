import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


class TeEther(Parser.Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(Parser.exceptions(output))
        exploit = []
        for line in self._lines:
            if "sendTransaction" in line:
                exploit.append(line)
        self._analysis = [ { 'exploit': exploit } ]
    
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
