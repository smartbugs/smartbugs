from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRuleIdFromMessage, parseUri, parseMessage, parseLevel


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

    def parseSarif(self, maian_output_results):
        resultsList = []
        rulesList = []

        uri = parseUri(maian_output_results["contract"])

        locations = [Location(physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=uri)))]

        if maian_output_results["analysis"]["is_lock_vulnerable"]:
            ruleId = parseRuleIdFromMessage("LockVulnerable")
            message = parseMessage("Lock Vulnerability Found!")
            resultsList.append(Result(rule_id=ruleId,
                                      message=Message(text=message),
                                      level=parseLevel("error"),
                                      locations=locations))
            rulesList.append(ReportingDescriptor(id=ruleId, short_description=MultiformatMessageString(message)))
        if maian_output_results["analysis"]["is_prodigal_vulnerable"]:
            ruleId = parseRuleIdFromMessage("ProdigalVulnerable")
            message = parseMessage("Prodigal Vulnerability Found!")
            resultsList.append(Result(rule_id=ruleId,
                                      message=Message(text=message),
                                      level=parseLevel("error"),
                                      locations=locations))
            rulesList.append(ReportingDescriptor(id=ruleId, short_description=MultiformatMessageString(message)))
        if maian_output_results["analysis"]["is_suicidal_vulnerable"]:
            ruleId = parseRuleIdFromMessage("SuicidalVulnerable")
            message = parseMessage("Suicidal Vulnerability Found!")
            resultsList.append(Result(rule_id=ruleId,
                                      message=Message(text=message),
                                      level=parseLevel("error"),
                                      locations=locations))
            rulesList.append(ReportingDescriptor(id=ruleId, short_description=MultiformatMessageString(message)))

        artifact = Artifact(location=ArtifactLocation(uri=uri), source_language="Solidity")

        tool = Tool(driver=ToolComponent(name="Maian", version="5.10", rules=rulesList,
                                         information_uri="https://github.com/ivicanikolicsg/MAIAN",
                                         full_description=MultiformatMessageString(
                                             text="Maian is a tool for automatic detection of buggy Ethereum smart contracts of three different types prodigal, suicidal and greedy.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run
