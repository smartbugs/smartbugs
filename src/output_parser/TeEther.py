import re

import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation

ERRORS = (
    (re.compile("Failed path due to Symbolic code index"), "Failed path due to Symbolic code index"),
    (re.compile("Failed path due to balance of symbolic address"), "Failed path due to balance of symbolic address"),
    (re.compile("Failed path due to b'Argument .* does not match declaration"), "Failed path due to argument not matching declaration"),
)

MESSAGES = (
    ("INFO:root:Could not exploit any RETURN+CALL", "Could not exploit any RETURN+CALL"),
    ("WARNING:root:No state-dependent critical path found, aborting", "No state-dependent critical path found"),
)

class TeEther(Parser.Parser):
    NAME = "teether"
    VERSION = "2022/07/23"
    PORTFOLIO = { "Ether leak" }

    def __init__(self, task: "Execution_Task", output: str):
        super().__init__(task, output)
        self._errors.discard('EXIT_CODE_1') # there will be an exception in self._fails anyway
        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return
        self._fails.update(Parser.exceptions(self._lines))

        # the following exceptions are also reported as errors below
        for f in list(self._fails): # copies self._fails, so we can modify it
            if "teether.evm.exceptions.SymbolicError:" in f:
                self._fails.remove(f)

        exploit = []
        analysis_completed = False
        for line in self._lines:
            if line.startswith("INFO:root:Could not exploit any RETURN+CALL"):
                self._messages.add("Could not exploit any RETURN+CALL")
                analysis_completed = True
            elif line.startswith("WARNING:root:No state-dependent critical path found, aborting"):
                self._messages.add("No state-dependent critical path found")
                analysis_completed = True
            elif line.startswith("eth.sendTransaction"):
                exploit.append(line)
                self._findings.add("Ether leak")
                analysis_completed = True
            elif line.startswith("ERROR:root:"):
                line = line[11:]
                e = Parser.truncate_message(line)
                for indicator,error in ERRORS:
                    if indicator.match(line):
                        e = error
                self._errors.add(e)
        if not analysis_completed:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')
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
