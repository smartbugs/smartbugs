if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import numpy,json,os,tarfile
from sarif_om import Tool, ToolComponent, Run, MultiformatMessageString
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseLogicalLocation, parseArtifact, \
    parseRule, parseResult, isNotDuplicateLogicalLocation


class Securify(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is not None and 'Exception in thread "main" java.io.IOException' in output:
            self._errors.add('exception occurred')
        try:
            self._analysis = json.loads(output)
            return
        except:
            pass
        result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
        try:
            with tarfile.open(result_tar, 'r') as tar:
                try:
                    results_json = tar.extractfile('results/results.json')
                    self._analysis = json.loads(results_json.read())
                    return
                except:
                    live_json = tar.extractfile('results/live.json')
                    self._analysis = {
                        f"{self._task.file}:{self._task.file_name}": {
                            'results': json.loads(live_json.read())["patternResults"]
                        }
                    }
        except Exception as e:
            self._errors.add(f'problem accessing result in {result_tar}')

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


if __name__ == '__main__':
    import Parser
    Parser.main(Securify)

