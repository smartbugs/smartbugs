import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class EthBMC(Parser.Parser):
    NAME = "ethbmc"
    VERSION = "2022/07/22"

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return
        self._fails.update(Parser.exceptions(self._lines))

        coverage = None
        analysis_completed = False
        for line in self._lines:
            if "Code covered: " in line:
                coverage = line.split("Code covered: ")[1]
            elif "Found attack, " in line:
                self._findings.add(line.split("Found attack, ")[1])
            elif "Finished analysis in" in line:
                analysis_completed = True
        analysis = { 'exploit': sorted(self._findings) }
        if coverage is not None:
            analysis['coverage'] = coverage
        self._analysis = [ analysis ]
        if not analysis_completed:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')

    
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
