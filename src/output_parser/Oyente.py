from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, isNotDuplicateArtifact, parseRule, parseResult, \
    parseArtifact, parseLogicalLocation


class Oyente(Parser):
    def __init__(self):
        pass

    def extract_result_line(self, line):
        line = line.replace("INFO:symExec:	  ", '')
        index_split = line.index(":")
        key = line[:index_split].lower().replace(' ', '_').replace('(', '').replace(')', '').strip()
        value = line[index_split + 1:].strip()
        if "True" == value:
            value = True
        elif "False" == value:
            value = False
        return key, value

    def parse(self, str_output):
        output = []
        current_contract = None
        lines = str_output.splitlines()
        for line in lines:
            if "INFO:root:contract" in line:
                if current_contract is not None:
                    output.append(current_contract)
                current_contract = {
                    'errors': []
                }
                (file, contract_name, _) = line.replace("INFO:root:contract ", '').split(':')
                current_contract['file'] = file
                current_contract['name'] = contract_name
            elif "INFO:symExec:	  " in line:
                (key, value) = self.extract_result_line(line)
                current_contract[key] = value
            elif current_contract and current_contract['file'] in line:
                if "INFO:symExec:" not in line:
                    line = "INFO:symExec:" + line
                (line, column, level, message) = line.replace("INFO:symExec:%s:" % (current_contract['file']),
                                                              '').split(':')
                current_contract['errors'].append({
                    'line': int(line),
                    'column': int(column),
                    'level': level.strip(),
                    'message': message.strip()
                })
        if current_contract is not None:
            output.append(current_contract)
        return output

    def parseSarif(self, oyente_output_results):
        resultsList = []
        artifactsList = []
        logicalLocationsList = []
        rulesList = []

        for analysis in oyente_output_results["analysis"]:
            artifact = None
            logicalLocation = None

            for result in analysis["errors"]:
                rule = parseRule(tool="oyente", vulnerability=result["message"])
                result = parseResult(tool="oyente", vulnerability=result["message"], level=result["level"],
                                     uri=analysis["file"], line=result["line"], column=result["column"])

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

                artifact = parseArtifact(uri=analysis["file"])
                logicalLocation = parseLogicalLocation(name=analysis["name"])

            if artifact != None and isNotDuplicateArtifact(artifact, artifactsList): artifactsList.append(artifact)
            if logicalLocation != None: logicalLocationsList.append(logicalLocation)

        tool = Tool(driver=ToolComponent(name="Oyente", version="0.4.25", rules=rulesList,
                                         information_uri="https://oyente.tech/",
                                         full_description=MultiformatMessageString(
                                             text="Oyente runs on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Oyente works directly with EVM bytecode without access high level representation and does not provide soundness nor completeness.")))

        run = Run(tool=tool, artifacts=artifactsList, logical_locations=logicalLocationsList, results=resultsList)

        return run
