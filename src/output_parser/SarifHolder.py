import attr
import pandas
from sarif_om import *

VERSION = "2.1.0"
SCHEMA = "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json"


class SarifHolder:
    def __init__(self):
        self.sarif = SarifLog(runs=[], version=VERSION, schema_uri=SCHEMA)
        self.translationDict = dict()

    # each analysis is defined by a Run
    def addRun(self, run):
        self.sarif.runs.append(run)

    # to print the analysis from a given tool
    def printToolRun(self, tool):
        run = -1
        for i in range(len(self.sarif.runs)):
            if self.sarif.runs[i].tool.driver.name.lower() == tool.lower():
                run = i
        sarifIndividual = SarifLog(runs=[], version=VERSION, schema_uri=SCHEMA)
        if run != -1:
            sarifIndividual.runs.append(self.sarif.runs[run])
        return self.serializeSarif(sarifIndividual)

    # print json formatted the SARIF file
    def print(self):
        return self.serializeSarif(self.sarif)

    # creates dictionary to fix variable names from sarif_om to standard sarif
    def serialize(self, inst, field, value):
        if field is not None:
            self.translationDict[field.name] = field.metadata['schema_property_name']
        return value

    # filters SARIF keys to discard default values in output
    def filterUnusedKeys(self, field, value):
        return not (value is None or (field.default == value and field.name != "level") or (
                isinstance(field.default, attr.Factory) and field.default.factory() == value))

    # returns a dictionary based on the schema_property_name and the values of the SARIF object
    def serializeSarif(self, sarifObj):
        valuesDict = attr.asdict(sarifObj, filter=self.filterUnusedKeys, value_serializer=self.serialize)
        return self.recursiveSarif(valuesDict)

    # uses translationDict to fix variable names from sarif_om to standard SARIF
    def recursiveSarif(self, serializedSarif):
        if isinstance(serializedSarif, (int, str)):
            return serializedSarif
        if isinstance(serializedSarif, dict):
            dic = dict()
            for key, value in serializedSarif.items():
                dic[self.translationDict[key]] = self.recursiveSarif(value)
            return dic
        if isinstance(serializedSarif, list):
            lis = list()
            for item in serializedSarif:
                lis.append(self.recursiveSarif(item))
            return lis


def parseRule(tool, vulnerability, full_description=None):
    vuln_info = findVulnerabilityOnTable(tool, vulnerability)

    if full_description is None:
        return ReportingDescriptor(id=vuln_info["RuleId"],
                                   short_description=MultiformatMessageString(
                                       vuln_info["Vulnerability"]),
                                   name=vuln_info["Type"] + "Vulnerability")

    return ReportingDescriptor(id=vuln_info["RuleId"],
                               short_description=MultiformatMessageString(
                                   vuln_info["Vulnerability"]),
                               full_description=MultiformatMessageString(full_description),
                               name=vuln_info["Type"])


def parseResult(tool, vulnerability, level="warning", uri=None, line=None, end_line=None, column=None, snippet=None,
                logicalLocation=None):
    vuln_info = findVulnerabilityOnTable(tool, vulnerability)

    level = parseLevel(level)

    uri = parseUri(uri)

    locations = [
        Location(physical_location=PhysicalLocation(artifact_location=ArtifactLocation(uri=uri),
                                                    region=Region(start_line=line,
                                                                  end_line=end_line,
                                                                  start_column=column,
                                                                  snippet=ArtifactContent(text=snippet))))
    ]

    if logicalLocation is not None:
        locations[0].logical_locations = [logicalLocation]

    return Result(rule_id=vuln_info["RuleId"],
                  message=Message(text=vulnerability),
                  level=level,
                  locations=locations)


def parseArtifact(uri, source_language="Solidity"):
    uri = parseUri(uri)

    return Artifact(location=ArtifactLocation(uri=uri), source_language=source_language)


def parseLogicalLocation(name, kind="contract"):
    return LogicalLocation(name=name, kind=kind)


# returns the row from the table for a given vulnerability and tool
def findVulnerabilityOnTable(tool, vulnerability_found):
    table = pandas.read_csv("src/output_parser/sarif_vulnerability_mapping.csv")

    tool_table = table.loc[table["Tool"] == tool]

    # Due to messages that have extra information (for example the line where the vulnerability was found) this loop
    # will search if the vulnerability expressed on table exist inside vulnerability found
    for index, row in tool_table.iterrows():
        if row["Vulnerability"] in vulnerability_found or vulnerability_found in row["Vulnerability"]:
            return row
    raise BaseException(
        'Vulnerability not found on sarif_vulnerability_mapping.csv table. Tool: {}, Vulnerability: {}'.format(tool,
                                                                                                               vulnerability_found))

# given a level produced by a tool, returns the level in SARIF format
def parseLevel(level):
    if isinstance(level, int):
        return "warning"
    if level.lower() == "warning" or level.lower() == "warnings" or level.lower() == "medium":
        return "warning"
    if level.lower() == "error" or level.lower() == "violations" or level.lower() == "high":
        return "error"
    if level.lower() == "note" or level.lower() == "conflicts" or level.lower() == "informational":
        return "note"
    if level.lower == "none" or level.lower() == "safe":
        return "none"
    return "warning"


# removes "/" on the begging of the URI for compatibility issues
def parseUri(uri):
    if uri is None: return None
    if len(uri) == 0: return ""
    if uri[0] == '/': return parseUri(uri[1:])
    return uri


# Returns True when rule is unique
def isNotDuplicateRule(newRule, rulesList):
    for rule in rulesList:
        if rule.id == newRule.id:
            return False
    return True


# Returns True when artifact is unique
def isNotDuplicateArtifact(newArtifact, artifactsList):
    for artifact in artifactsList:
        if artifact.location.uri == newArtifact.location.uri:
            return False
    return True
