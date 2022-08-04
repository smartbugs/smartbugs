import numpy,json,os,tarfile
import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, Run, MultiformatMessageString
from src.output_parser.SarifHolder import parseLogicalLocation, parseArtifact, \
    parseRule, parseResult, isNotDuplicateLogicalLocation


class Securify(Parser.Parser):
    NAME = "securify"
    VERSION = "2022/08/04"
    PORTFOLIO = {
        "DAO",
        "DAOConstantGas",
        "MissingInputValidation",
        "TODAmount",
        "TODReceiver",
        "TODTransfer",
        "UnhandledException",
        "UnrestrictedEtherFlow"
    }

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        self._fails.update(Parser.exceptions(self._lines))
        if self._fails:
            self._errors.discard('EXIT_CODE_1')
        # We look for the output in the following order:
        # result.log (= output)
        # result.tar/results.json
        # result.tar/live.json
        try:
            self._analysis = json.loads(output)
        except:
            result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
            try:
                with tarfile.open(result_tar, 'r') as tar:
                    try:
                        jsn = tar.extractfile('results/results.json')
                        self._analysis = json.loads(jsn.read())
                    except:
                        jsn = tar.extractfile('results/live.json')
                        self._analysis = json.loads(jsn.read())
            except Exception as e:
                if not self._fails:
                    self._fails.add('output missing')
                return
        if "patternResults" in self._analysis: # live.json
            if "finished" in self._analysis and not self._analysis["finished"]:
                self._messages.add('analysis incomplete')
            if "decompiled" in self._analysis and not self._analysis["decompiled"]:
                self._errors.add('decompilation error')
            for vuln,check in self._analysis["patternResults"].items():
                if not check["completed"]:
                    self._messages.add('analysis incomplete')
                if check["hasViolations"]:
                    self._findings.add(vuln)
            if 'analysis incomplete' in self._messages and not self._fails:
                self._fails.add("execution failed")
        else: # output or result.json
            for contract,analysis in self._analysis.items():
                for vuln,check in analysis["results"].items():
                    if check["violations"]:
                        self._findings.add(vuln)


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
