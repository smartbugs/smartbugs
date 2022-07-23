import re
import src.output_parser.Parser as Parser
from sarif_om import *
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, \
    parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation
from src.execution.execution_task import Execution_Task


MESSAGES = (
    re.compile("(incomplete push instruction) at [0-9]+"),
)

# ERRORS also for Osiris and Honeybadger
ERRORS = (
    re.compile("(UNKNOWN INSTRUCTION: .*)"),
    re.compile("!!! (SYMBOLIC EXECUTION TIMEOUT) !!!"),
    re.compile("CRITICAL:root:(Solidity compilation failed)"),
)

FAILS = (
#    re.compile("(Unexpected error: .*)"), # Secondary error
)

class Oyente(Parser.Parser):
    NAME = "oyente"
    VERSION = "2022/07/23"
    PORTFOLIO = {
        "Callstack Depth Attack Vulnerability",
        "Transaction-Ordering Dependence (TOD)",
        "Timestamp Dependency",
        "Re-Entrancy Vulnerability",
    }

    @staticmethod
    def __skip(line):
        return (
            line.startswith("888")
            or line.startswith("`88b")
            or line.startswith("!!! ")
            or line.startswith("UNKNOWN INSTRUCTION:")
        )

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        self._errors.discard('EXIT_CODE_1') # redundant: exit code 1 is reflected in other errors, or just indicates that a vulnerability has been found

        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return

        self._fails.update(Parser.exceptions(self._lines, Oyente.__skip))

        self._analysis = []
        analysis_completed = False
        contract = None
        for line in self._lines:
            if Parser.add_match(self._messages, line, MESSAGES):
                continue
            if Parser.add_match(self._errors, line, ERRORS):
                continue
            if Parser.add_match(self._fails, line, FAILS):
                continue

            fields = [ f.strip().replace('└> ','') for f in line.split(':') ]
            if (line.startswith('INFO:root:contract') or line.startswith('INFO:root:Contract')) and len(fields) >= 4:
                # INFO:root:contract <filename>:<contract name>:
                if contract is not None:
                    self._analysis.append(contract)
                contract = {
                    'file': fields[2].replace('contract ', '').replace('Contract ',''),
                    'contract': fields[3]
                }
                key = None
                val = None
                analysis_completed = False
            elif line.startswith('INFO:symExec:\t'):
                if fields[2] == '============ Results ===========':
                    # INFO:symExec:   ============ Results ===========
                    pass
                elif fields[2] == '====== Analysis Completed ======':
                    # INFO:symExec:   ====== Analysis Completed ======
                    analysis_completed = True
                elif len(fields) >= 4:
                    # INFO:symExec:<key>:<value>
                    if contract is None:
                        contract = {}
                    key = fields[2]
                    val = fields[3]
                    if val == 'True':
                        contract[key] = True
                        self._findings.add(key)
                    elif val == 'False':
                        contract[key] = False
                    else:
                        contract[key] = val
            elif contract is not None and 'file' in contract:
                fn = contract['file']
                if 'issues' not in contract:
                    contract['issues'] = []
                if line.startswith(f"INFO:symExec:{fn}") and len(fields) >= 7:
                    # INFO:symExec:<filename>:<line>:<column>:<level>:<message>
                    contract['issues'].append({
                        'line':    int(fields[3]),
                        'column':  int(fields[4]),
                        'level':   fields[5],
                        'message': fields[6]
                    })
                elif line.startswith(fn) and len(fields) >= 5:
                    # <filename>:<line>:<column>:<level>:<message>
                    contract['issues'].append({
                        'line':    int(fields[1]),
                        'column':  int(fields[2]),
                        'level':   fields[3],
                        'message': fields[4]
                    })
                elif line.startswith(fn) and len(fields) >= 4:
                    # <filename>:<contract>:<line>:<column>
                    assert 'contract' in contract and contract['contract'] == fields[1]
                    assert key is not None and val == 'True'
                    contract['issues'].append({
                        'line':    int(fields[2]),
                        'column':  int(fields[3]),
                        'message': key
                    })
        if contract is not None:
            self._analysis.append(contract)

        if not analysis_completed:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')

        # Remove errors/fails issued twice, once via exception and once via print statement
        if "SYMBOLIC EXECUTION TIMEOUT" in self._errors and "exception (Exception: timeout)" in self._fails:
            self._fails.remove("exception (Exception: timeout)")
        for e in list(self._fails): # list() makes a copy, so we can modify the set in the loop
            if e == "exception (Exception: timeout)":
                self._fails.remove(e)
                if not "SYMBOLIC EXECUTION TIMEOUT" in self._errors:
                    self._errors.add(e)
            elif "UNKNOWN INSTRUCTION" in e:
                self._fails.remove(e)
                if not e[22:-1] in self._errors:
                    self._errors.add(e)


    def parseSarif(self, oyente_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in oyente_output_results["analysis"]:
            for result in analysis["errors"]:
                rule = parseRule(tool="oyente", vulnerability=result["message"])
                result = parseResult(tool="oyente", vulnerability=result["message"], level=result["level"],
                                     uri=file_path_in_repo, line=result["line"], column=result["column"])

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

            if "name" in analysis:
                logicalLocation = parseLogicalLocation(name=analysis["name"])

                if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                    logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Oyente", version="0.4.25", rules=rulesList,
                                         information_uri="https://oyente.tech/",
                                         full_description=MultiformatMessageString(
                                             text="Oyente runs on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Oyente works directly with EVM bytecode without access high level representation and does not provide soundness nor completeness.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run
