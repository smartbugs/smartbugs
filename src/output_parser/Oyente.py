if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import *
from src.output_parser.Parser import Parser, python_errors
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, \
    parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation
from src.execution.execution_task import Execution_Task

ERRORS = (
    ('incomplete push instruction', 'instruction error'),
    ('UNKNOWN INSTRUCTION', 'instruction error'),
    ('!!! SYMBOLIC EXECUTION TIMEOUT !!!', 'timeout'),
    ('CRITICAL:root:Solidity compilation failed', 'compilation failed'),
    ('Exception z3.z3types.Z3Exception', 'Z3 exception')
)

class Oyente(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(output))
        for indicator,error in ERRORS:
            if indicator in output:
                self._errors.add(error)
        (self._analysis, self._findings, analysis_completed) = Oyente.__parse(self._lines)
        if not analysis_completed:
            self._errors.add('analysis incomplete')

    @staticmethod
    def __parse(lines):
        analysis = []
        findings = set()
        analysis_completed = False
        contract = None
        for line in lines:
            fields = [ f.strip().replace('└> ','') for f in line.split(':') ]
            if (line.startswith('INFO:root:contract') or line.startswith('INFO:root:Contract')) and len(fields) >= 4:
                # INFO:root:contract <filename>:<contract name>:
                if contract is not None:
                    analysis.append(contract)
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
                        findings.add(key)
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
            analysis.append(contract)
        return (analysis,findings,analysis_completed)

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


if __name__ == '__main__':
    import Parser
    Parser.main(Oyente)
