import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


KEYS = (
        ('input:', 'input'),
        ('result:', 'result'),
        ('Coverage:', 'coverage')
)

class EasyFlow(Parser.Parser):
    NAME = "easyflow"
    VERSION = "2022/07/22"

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return
        self._fails.update(Parser.exceptions(self._lines))
        analysis = {}
        for line in self._lines:
            for indicator,key in KEYS:
                if indicator in line:
                    analysis[key] = line.split(indicator)[1].strip()
                    break
        if 'result' in analysis:
            self._findings.add(analysis['result'])
        self._analysis = [analysis]
    
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
