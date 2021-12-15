from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, \
    parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class Oyente(Parser):

    def __init__(self, task: 'Execution_Task', str_output: str):
        super().__init__(task, str_output)
        if str_output is None:
            return
        (output, labels) = Oyente.__parse_output(str_output)
        self.output = output
        self.labels = sorted(labels)
        self.success = '====== Analysis Completed ======' in str_output

    @staticmethod
    def __parse_output(str_output: str):
        labels = set()
        output = []
        contract = None
        lines = str_output.splitlines()
        for line in lines:
            fields = [ f.strip() for f in line.split(':') ]
            if line.startswith('INFO:root:contract') and len(fields) >= 4:
                # INFO:root:contract <filename>:<contract name>:
                if contract is not None:
                    output.append(contract)
                contract = {
                    'errors': [],
                    'file': fields[2].replace('contract ', ''),
                    'name': fields[3]
                }
            elif line.startswith('INFO:symExec:\t') and len(fields) >= 4:
                # INFO:symExec:<key>:<value>
                if contract is None:
                    contract = {'errors': []}
                key = Parser.str2label(fields[2])
                val = fields[3]
                if val == 'True':
                    contract[key] = True
                    labels.add(key)
                elif val == 'False':
                    contract[key] = False
                else:
                    contract[key] = val
            elif contract is not None and 'file' in contract:
                fn = contract['file']
                if line.startswith(fn) and len(fields) >= 5:
                    # <filename>:<line>:<column>:<level>:<message>
                    contract['errors'].append({
                        'line':    int(fields[1]),
                        'column':  int(fields[2]),
                        'level':   fields[3],
                        'message': fields[4]
                    })
                elif line.startswith(f"INFO:symExec:{fn}") and len(fields) >= 7:
                    # INFO:symExec:<filename>:<line>:<column>:<level>:<message>
                    contract['errors'].append({
                        'line':    int(fields[3]),
                        'column':  int(fields[4]),
                        'level':   fields[5],
                        'message': fields[6]
                    })
        if contract is not None:
            output.append(contract)
        return (output, labels)

    def parseSarif(self, oyente_output_results, file_path_in_repo):
        # oyente_output_results obsolete, kept for compatibility
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in self.output:
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
