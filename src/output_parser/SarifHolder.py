import attr
from sarif_om import *

VERSION = "2.1.0"
SCHEMA = "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json"


class SarifHolder:
    def __init__(self):
        self.sarif = SarifLog(runs=[], version=VERSION, schema_uri=SCHEMA)
        self.translationDict = dict()

    def addRun(self, run):
        self.sarif.runs.append(run)

    def printToolRun(self, tool):
        run = -1
        for i in range(len(self.sarif.runs)):
            if self.sarif.runs[i].tool.driver.name.lower() == tool.lower():
                run = i
        sarifIndividual = SarifLog(runs=[], version=VERSION, schema_uri=SCHEMA)
        if run != -1:
            sarifIndividual.runs.append(self.sarif.runs[run])
        return self.serializeSarif(sarifIndividual)

    def print(self):
        return self.serializeSarif(self.sarif)

    def serialize(self, inst, field, value):
        self.translationDict[field.name] = field.metadata['schema_property_name']
        return value

    def filter(self, field, value):
        if (field.default == value and field.name != "level") or (
                isinstance(field.default, attr.Factory) and field.default.factory() == value):
            return False
        return True

    # returns a dictionary based on the schema_property_name and the values of the sarif object
    def serializeSarif(self, sarifObj):
        valuesDict = attr.asdict(sarifObj, filter=self.filter, value_serializer=self.serialize)
        return self.recursiveSarif(valuesDict)

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


def parseRuleIdFromMessage(message):
    return message.replace(" ", "")


def parseLevel(level):
    if level.lower() == "warning":
        return "warning"
    if level.lower() == "error":
        return "error"
    if level.lower() == "note":
        return "note"
    return "none"


def parseMessage(message):
    return message


def parseUri(uri):
    if len(uri) == 0: return uri
    if uri[0] == '/': return parseUri(uri[1:])
    return uri


translationDict = dict()
