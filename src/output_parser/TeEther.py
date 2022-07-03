import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation


FINDINGS = (
    "INFO:root:Could not exploit any RETURN+CALL",
    "WARNING:root:No state-dependent critical path found, aborting",
    "eth.sendTransaction",
    )

class TeEther(Parser.Parser):
    NAME = "teether"
    VERSION = "2022/07/03"

    def __init__(self, task: "Execution_Task", output: str):
        super().__init__(task, output)
        if not output:
            self._errors.add("output missing")
            return
        self._errors.update(Parser.exceptions(output))
        exploit = []
        analysis_complete = False
        for line in self._lines:
            for indicator in FINDINGS:
                if line.startswith(indicator):
                    analysis_complete = True
            if line.startswith("eth.sendTransaction"):
                exploit.append(line)
                self._findings.add("Ether leak")
            if line.startswith("ERROR:root:"):
                self._errors.add(Parser.truncate_message(line))
        if not analysis_complete:
            self._errors.add('analysis incomplete')
        self._analysis = [ { 'exploit': exploit } ] if exploit else [ {} ]
    
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
