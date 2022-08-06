import re

import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation

FAILED_PATH = re.compile("Failed path due to (.*)")

ERRORS = (
    "Failed path due to Symbolic code index",
    "Failed path due to balance of symbolic address"
)

MESSAGES = (
    ("INFO:root:Could not exploit any RETURN+CALL", "Could not exploit any RETURN+CALL"),
    ("WARNING:root:No state-dependent critical path found, aborting", "No state-dependent critical path found"),
)

class TeEther(Parser.Parser):
    NAME = "teether"
    VERSION = "2022/08/05"
    PORTFOLIO = { "Ether leak" }

    def __init__(self, task: "Execution_Task", output: str):
        super().__init__(task, output)
        self._errors.discard('EXIT_CODE_1') # there will be an exception in self._fails anyway
        for f in list(self._fails): # copies self._fails, so we can modify it
            if f.startswith("exception (teether.evm.exceptions."): # reported as error below
                self._fails.remove(f)
            elif f.startswith("exception (z3.z3types.Z3Exception: b'Argument "):
                self._fails.remove(f)
                self._fails.add("exception (z3.z3types.Z3Exception: Argument does not match function declaration")



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
                error = line[11:]
                # Skip errors already reported as an exception
                if error.startswith("Failed path due to b'Argument "):
                    continue
                if m := FAILED_PATH.match(error):
                    if any(m[1] in f for f in self._fails):
                        continue
                for e in ERRORS:
                    if error.startswith(e):
                        error = e
                        break
                self._errors.add(error)

        if self._lines and not analysis_completed:
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
