from sarif_om import *

from src.output_parser.SarifHolder import isNotDuplicateRule, isNotDuplicateArtifact, parseLogicalLocation, parseRule, \
    parseResult, parseArtifact


class Mythril:

    def parseSarif(self, mythril_output_results):
        artifactsList = []
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        for issue in mythril_output_results["analysis"]["issues"]:
            uri = issue["filename"]
            rule = parseRule(tool="mythril", vulnerability=issue["title"], full_description=issue["description"])
            result = parseResult(tool="mythril", vulnerability=issue["title"], level=issue["type"], uri=uri,
                                 line=issue["lineno"], snippet=issue["code"],
                                 logicalLocation=parseLogicalLocation(issue["function"],
                                                                      kind="function"))

            # checking duplicates
            unique = True
            for value in logicalLocationsList:
                if value.name == issue["function"]:
                    unique = False
            if unique:
                logicalLocationsList.append(parseLogicalLocation(name=issue["function"], kind="function"))
            resultsList.append(result)

            artifact = parseArtifact(uri=uri)

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
