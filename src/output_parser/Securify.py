import numpy
import json
import os
import tarfile

from sarif_om import *
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseLogicalLocation, parseArtifact, \
    parseRule, parseResult, isNotDuplicateLogicalLocation


class Securify(Parser):

    def is_success(self) -> bool:
        try:
            with tarfile.open(os.path.join(self.task.result_output_path(), 'result.tar'), 'r') as tar:
                return True
        except e:
            return False

    def parse(self):
        if len(self.str_output) > 0 and self.str_output[0] == '{':
            return json.loads(self.str_output)
        elif os.path.exists(os.path.join(self.task.result_output_path(), 'result.tar')):
            tar = tarfile.open(os.path.join(
                self.task.result_output_path(), 'result.tar'))
            try:
                output_file = tar.extractfile('results/results.json')
                return json.loads(output_file.read())
            except:
                try:
                    output_file = tar.extractfile('results/live.json')
                    out = {}
                    out["%s:%s" % (self.task.file, self.task.file_name)] = {
                        'results': json.loads(output_file.read())["patternResults"]
                    }
                    return out
                except:
                    return None

    def parseSarif(self, securify_output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []
        if securify_output_results["analysis"] is not None:
            for name, analysis in securify_output_results["analysis"].items():

                contractName = name.split(':')[1]
                logicalLocation = parseLogicalLocation(name=contractName)

                if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                    logicalLocationsList.append(logicalLocation)

                for vuln, analysisResult in analysis["results"].items():
                    rule = parseRule(tool="securify", vulnerability=vuln)
                    # Extra loop to add unique rule to tool in sarif
                    for level, lines in analysisResult.items():
                        if hasattr(lines, "__len__") and len(lines) > 0:
                            rulesList.append(rule)
                            break
                    for level, lines in analysisResult.items():
                        if hasattr(lines, "__len__"):
                            for lineNumber in lines:
                                result = parseResult(tool="securify", vulnerability=vuln, level=level, uri=file_path_in_repo,
                                                    line=lineNumber)
                                resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Securify", version="0.4.25", rules=rulesList,
                                         information_uri="https://github.com/eth-sri/securify2",
                                         full_description=MultiformatMessageString(
                                             text="Securify uses formal verification, also relying on static analysis checks. Securify’s analysis consists of two steps. First, it symbolically analyzes the contract’s dependency graph to extract precise semantic information from the code. Then, it checks compliance and violation patterns that capture sufficient conditions for proving if a property holds or not.")))

        run = Run(tool=tool, artifacts=[
                  artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run

    def parseSarifFromLiveJson(self, securify_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        for name, analysis in securify_output_results["analysis"].items():
            for vuln, analysisResult in analysis["results"].items():
                rule = parseRule(tool="securify", vulnerability=vuln)
                # Extra loop to add unique rule to tool in sarif
                for level, lines in analysisResult.items():
                    if not isinstance(lines, list):
                        continue
                    if len(lines) > 0:
                        rulesList.append(rule)
                        break
                for level, lines in analysisResult.items():
                    if not isinstance(lines, list):
                        continue
                    for lineNumber in list(numpy.unique(lines)):
                        result = parseResult(tool="securify", vulnerability=vuln, level=level, uri=file_path_in_repo,
                                             line=int(lineNumber))  # without int() lineNumber returns null??!

                        resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Securify", version="0.4.25", rules=rulesList,
                                         information_uri="https://github.com/eth-sri/securify2",
                                         full_description=MultiformatMessageString(
                                             text="Securify uses formal verification, also relying on static analysis checks. Securify’s analysis consists of two steps. First, it symbolically analyzes the contract’s dependency graph to extract precise semantic information from the code. Then, it checks compliance and violation patterns that capture sufficient conditions for proving if a property holds or not.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run
