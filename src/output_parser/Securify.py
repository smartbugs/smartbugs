import numpy
from sarif_om import *

from src.output_parser.SarifHolder import parseRuleIdFromMessage, parseUri, parseMessage, parseLevel


class Securify:

    def parseSarif(self, securify_output_results):
        artifactsList = []
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for name, analysis in securify_output_results["analysis"].items():
            fileLocation = parseUri(name.split(':')[0])
            contractName = name.split(':')[1]
            logicalLocationsList.append(LogicalLocation(name=contractName, kind="contract"))
            artifactsList.append(Artifact(location=ArtifactLocation(uri=fileLocation), source_language="Solidity"))
            for vuln, analysisResult in analysis["results"].items():
                ruleId = parseRuleIdFromMessage(vuln)
                # Extra loop to add unique rule to tool in sarif
                for level, lines in analysisResult.items():
                    if len(lines) > 0:
                        rulesList.append(
                            ReportingDescriptor(id=ruleId,
                                                short_description=MultiformatMessageString(parseMessage(vuln))))
                        break
                for level, lines in analysisResult.items():
                    for lineNumber in lines:
                        locations = [Location(
                            physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=fileLocation),
                                                               region=Region(start_line=lineNumber)))]
                        resultsList.append(Result(rule_id=ruleId,
                                                  message=Message(text=parseMessage(vuln)),
                                                  level=parseLevel(level),
                                                  locations=locations))

        tool = Tool(driver=ToolComponent(name="Securify", version="0.4.25", rules=rulesList,
                                         information_uri="https://github.com/eth-sri/securify2",
                                         full_description=MultiformatMessageString(
                                             text="Securify uses formal verification, also relying on static analysis checks. Securify’s analysis consists of two steps. First, it symbolically analyzes the contract’s dependency graph to extract precise semantic information from the code. Then, it checks compliance and violation patterns that capture sufficient conditions for proving if a property holds or not.")))

        run = Run(tool=tool, artifacts=artifactsList, logical_locations=logicalLocationsList, results=resultsList)

        return run

    def parseSarifFromLiveJson(self, securify_output_results):
        artifactsList = []
        resultsList = []
        rulesList = []

        for name, analysis in securify_output_results["analysis"].items():
            artifactsList.append(Artifact(location=ArtifactLocation(uri=name), source_language="Solidity"))
            for vuln, analysisResult in analysis["results"].items():
                ruleId = parseRuleIdFromMessage(vuln)
                # Extra loop to add unique rule to tool in sarif
                for level, lines in analysisResult.items():
                    if not isinstance(lines, list):
                        continue
                    if len(lines) > 0:
                        rulesList.append(
                            ReportingDescriptor(id=ruleId,
                                                short_description=MultiformatMessageString(parseMessage(vuln))))
                        break
                for level, lines in analysisResult.items():
                    if not isinstance(lines, list):
                        continue
                    for lineNumber in list(numpy.unique(lines)):
                        locations = [Location(
                            physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=name),
                                                               region=Region(start_line=int(
                                                                   lineNumber))))]  # wtf? without int() lineNumber returns null??!
                        resultsList.append(Result(rule_id=ruleId,
                                                  message=Message(text=parseMessage(vuln)),
                                                  level=parseLevel(level),
                                                  locations=locations))

        tool = Tool(driver=ToolComponent(name="Securify", version="0.4.25", rules=rulesList,
                                         information_uri="https://github.com/eth-sri/securify2",
                                         full_description=MultiformatMessageString(
                                             text="Securify uses formal verification, also relying on static analysis checks. Securify’s analysis consists of two steps. First, it symbolically analyzes the contract’s dependency graph to extract precise semantic information from the code. Then, it checks compliance and violation patterns that capture sufficient conditions for proving if a property holds or not.")))

        run = Run(tool=tool, artifacts=artifactsList, results=resultsList)

        return run
