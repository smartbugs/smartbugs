from sarif_om import *

from src.output_parser.SarifHolder import parseLevel, parseUri, parseMessage, parseRuleIdFromMessage, \
    isNotDuplicateRule, isNotDuplicateArtifact


class Slither:

    def parseSarif(self, slither_output_results):
        rulesList = []
        resultsList = []
        artifactsList = []

        for analysis in slither_output_results["analysis"]:
            ruleId = parseRuleIdFromMessage(analysis["check"])
            level = parseLevel(analysis["impact"])
            message = parseMessage(analysis["description"])
            locations = []

            for element in analysis["elements"]:
                uri = parseUri(element["source_mapping"]["filename"])
                location = Location(physical_location=PhysicalLocation(
                    artifact_location=ArtifactLocation(uri=uri),
                    region=Region(start_line=element["source_mapping"]["lines"][0],
                                  end_line=element["source_mapping"]["lines"][-1])), logical_locations=[])
                artifact = Artifact(location=ArtifactLocation(uri=uri), source_language="Solidity")
                if isNotDuplicateArtifact(artifact, artifactsList):
                    artifactsList.append(artifact)

                if "name" in element.keys():
                    if "type" in element.keys():
                        location.logical_locations.append(LogicalLocation(name=element["name"], kind=element["type"]))
                    if "target" in element.keys():
                        location.logical_locations.append(LogicalLocation(name=element["name"], kind=element["target"]))
                if "expression" in element.keys():
                    location.physical_location.region.snippet = ArtifactContent(text=element["expression"])
                if "contract" in element.keys():
                    location.logical_locations.append(
                        LogicalLocation(name=element["contract"]["name"], kind=element["contract"]["type"]))
                locations.append(location)

            rule = ReportingDescriptor(id=ruleId, full_description=MultiformatMessageString(text=message))

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            resultsList.append(Result(rule_id=ruleId,
                                      message=Message(text=message),
                                      level=level,
                                      locations=locations))

        tool = Tool(driver=ToolComponent(name="Slither", version="0.7.0", rules=rulesList,
                                         information_uri="https://github.com/crytic/slither",
                                         full_description=MultiformatMessageString(
                                             text="Slither is a Solidity static analysis framework written in Python 3. It runs a suite of vulnerability detectors and prints visual information about contract details. Slither enables developers to find vulnerabilities, enhance their code comphrehension, and quickly prototype custom analyses.")))

        run = Run(tool=tool, artifacts=artifactsList, results=resultsList)

        return run
