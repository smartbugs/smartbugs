from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRuleIdFromMessage, parseLevel, parseMessage, parseUri, \
    isNotDuplicateRule, isNotDuplicateArtifact


class Solhint(Parser):
    def __init__(self):
        pass

    def parse(self, str_output):
        output = []
        lines = str_output.splitlines()
        for line in lines:
            if ":" in line:
                s_result = line.split(':')
                if len(s_result) != 4:
                    continue
                (file, line, column, end_error) = s_result
                if ']' not in end_error:
                    continue
                message = end_error[1:end_error.index('[') - 1]
                level = end_error[end_error.index('[') + 1: end_error.index('/')]
                type = end_error[end_error.index('/') + 1: len(end_error) - 1]
                output.append({
                    'file': file,
                    'line': line,
                    'column': column,
                    'message': message,
                    'level': level,
                    'type': type
                })

        return output

    def parseSarif(self, solhint_output_results):
        resultsList = []
        artifactsList = []
        rulesList = []

        for analysis in solhint_output_results["analysis"]:
            ruleId = parseRuleIdFromMessage(analysis["type"])
            message = Message(text=parseMessage(analysis["message"]))
            level = parseLevel(analysis["level"])
            uri = parseUri(analysis["file"])
            locations = [
                Location(physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=uri),
                                                            region=Region(start_line=int(analysis["line"]),
                                                                          start_column=int(analysis["column"]))))
            ]

            resultsList.append(Result(rule_id=ruleId,
                                      message=message,
                                      level=level,
                                      locations=locations))

            rule = ReportingDescriptor(id=ruleId,
                                       short_description=MultiformatMessageString(
                                           analysis["message"]))
            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            artifact = Artifact(location=ArtifactLocation(uri=uri), source_language="Solidity")

            if isNotDuplicateArtifact(artifact, artifactsList):
                artifactsList.append(artifact)

        logicalLocation = LogicalLocation(name=solhint_output_results["contract"], kind="contract")

        tool = Tool(driver=ToolComponent(name="Solhint", version="3.3.2", rules=rulesList,
                                         information_uri="https://protofire.github.io/solhint/",
                                         full_description=MultiformatMessageString(
                                             text="Open source project for linting solidity code. This project provide both security and style guide validations.")))

        run = Run(tool=tool, artifacts=artifactsList, logical_locations=[logicalLocation], results=resultsList)

        return run
