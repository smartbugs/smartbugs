from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, \
    parseResult, parseArtifact


class Maian(Parser):
    def __init__(self):
        pass

    def parse(self, str_output):
        output = {
            'is_lock_vulnerable': False,
            'is_prodigal_vulnerable': False,
            'is_suicidal_vulnerable': False,
        }
        lines = str_output.splitlines()
        for line in lines:
            if 'Locking vulnerability found!' in line:
                output['is_lock_vulnerable'] = True
            if 'The contract is prodigal' in line:
                output['is_prodigal_vulnerable'] = True
            if 'Confirmed ! The contract is suicidal' in line:
                output['is_suicidal_vulnerable'] = True
        return output

    def parseSarif(self, maian_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        for vulnerability in maian_output_results["analysis"].keys():
            if maian_output_results["analysis"][vulnerability]:
                rule = parseRule(tool="maian", vulnerability=vulnerability)
                result = parseResult(tool="maian", vulnerability=vulnerability, level="error",
                                     uri=file_path_in_repo)

                rulesList.append(rule)
                resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Maian", version="5.10", rules=rulesList,
                                         information_uri="https://github.com/ivicanikolicsg/MAIAN",
                                         full_description=MultiformatMessageString(
                                             text="Maian is a tool for automatic detection of buggy Ethereum smart contracts of three different types prodigal, suicidal and greedy.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run
