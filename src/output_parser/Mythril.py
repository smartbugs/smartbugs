from sarif_om import *

from src.output_parser.SarifHolder import parseRuleIdFromMessage, parseUri, parseMessage, parseLevel, \
    isNotDuplicateRule, isNotDuplicateArtifact


class Mythril:

    def parseSarif(self, mythril_output_results):
        artifactsList = []
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for issue in mythril_output_results["analysis"]["issues"]:
            uri = parseUri(issue["filename"])
            ruleId = parseRuleIdFromMessage(issue["title"])
            message = parseMessage(issue["description"])
            level = parseLevel(issue["type"])

            locations = [
                Location(physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=uri),
                                                            region=Region(start_line=issue["lineno"],
                                                                          snippet=ArtifactContent(
                                                                              text=issue["code"])))),
                Location(logical_locations=[LogicalLocation(name=issue["function"], kind="function")])
            ]
            # checking duplicates
            unique = True
            for value in logicalLocationsList:
                if value.name == issue["function"]:
                    unique = False
            if unique:
                logicalLocationsList.append(LogicalLocation(name=issue["function"], kind="function"))
            resultsList.append(Result(rule_id=ruleId,
                                      message=Message(text=message),
                                      level=level,
                                      locations=locations))

            rule = ReportingDescriptor(id=ruleId, short_description=MultiformatMessageString(text=issue["title"]),
                                       full_description=MultiformatMessageString(text=message))

            artifact = Artifact(location=ArtifactLocation(uri=uri), source_language="Solidity")

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            if isNotDuplicateArtifact(artifact, artifactsList):
                artifactsList.append(artifact)

        tool = Tool(driver=ToolComponent(name="Mythril", version="0.4.25", rules=rulesList,
                                         information_uri="https://mythx.io/",
                                         full_description=MultiformatMessageString(
                                             text="Mythril analyses EVM bytecode using symbolic analysis, taint analysis and control flow checking to detect a variety of security vulnerabilities.")))

        run = Run(tool=tool, artifacts=artifactsList, logical_locations=logicalLocationsList, results=resultsList)

        return run
