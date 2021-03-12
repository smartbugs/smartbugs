from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRuleIdFromMessage, parseUri, parseMessage, parseLevel, isNotDuplicateRule


class Manticore(Parser):
    def __init__(self):
        pass

    def parse(self, str_output):
        output = []
        lines = str_output.splitlines()

        current_vul = None
        for line in lines:
            if len(line) == 0:
                continue
            if line[0] == '-':
                if current_vul is not None:
                    output.append(current_vul)
                current_vul = {
                    'name': line[1:-2].strip(),
                    'line': -1,
                    'code': None
                }
            elif current_vul is not None and line[:4] == '    ':
                index = line[4:].rindex('  ') + 4
                current_vul['line'] = int(line[4:index])
                current_vul['code'] = line[index:].strip()

        if current_vul is not None:
            output.append(current_vul)
        return output

    def parseSarif(self, manticore_output_results):
        rulesList = []
        resultsList = []

        uri = parseUri(manticore_output_results["contract"] + ".sol")
        artifact = Artifact(location=ArtifactLocation(uri=uri), source_language="Solidity")

        for multipleAnalysis in manticore_output_results["analysis"]:
            for analysis in multipleAnalysis:
                ruleId = parseRuleIdFromMessage(analysis["name"])
                message = Message(text=parseMessage(analysis["name"]))
                level = parseLevel("warning")
                locations = [
                    Location(physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=uri),
                                                                region=Region(start_line=analysis["line"],
                                                                              snippet=ArtifactContent(
                                                                                  text=analysis["code"]))))
                ]

                resultsList.append(Result(rule_id=ruleId,
                                          message=message,
                                          level=level,
                                          locations=locations))

                rule = ReportingDescriptor(id=ruleId,
                                           short_description=MultiformatMessageString(
                                               analysis["name"]))
                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

        tool = Tool(driver=ToolComponent(name="Manticore", version="0.3.5", rules=rulesList,
                                         information_uri="https://github.com/trailofbits/manticore",
                                         full_description=MultiformatMessageString(
                                             text="Manticore is a symbolic execution tool for analysis of smart contracts and binaries.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run
