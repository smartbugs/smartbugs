if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, \
    parseLogicalLocation, isNotDuplicateLogicalLocation

FINDINGS = (
    (' secure', 'ethor_secure'),
    (' insecure', 'Reentrancy'),
)

ERRORS = (
    ('Encountered an unknown bytecode', 'instruction error'),
    ('Cannot allocate memory', 'memory allocation error'),
    ('Floating-point arithmetic', 'floating point error'),
    ('Undefined relation EXTCODEHASH', 'EXTCODEHASH error'),
    ('Segmentation fault', 'segmentation fault'),
    ('UnsupportedOperationException', 'unsupported operation exception'),
    ('RuntimeException', 'runtime exception'),
    ('Aborted', 'execution aborted'),
    ('Killed', 'execution killed'),
)

class EThor(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        for line in self._lines:
            for indicator,finding in FINDINGS:
                if indicator in line:
                    self._findings.add(finding)
            for indicator,error in ERRORS:
                if indicator in line:
                    self._errors.add(error)
        if not self._findings:
            self._errors.add('analysis incomplete')
        self._analysis = sorted(self._findings)

    ## TODO: Sarif
    def parseSarif(self, conkas_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []
        logicalLocationsList = []

        for analysis_result in conkas_output_results["analysis"]:
            rule = parseRule(tool="conkas", vulnerability=analysis_result["vuln_type"])

            logicalLocation = parseLogicalLocation(analysis_result["maybe_in_function"], kind="function")

            result = parseResult(tool="conkas", vulnerability=analysis_result["vuln_type"], uri=file_path_in_repo,
                                 line=int(analysis_result["line_number"]),
                                 logicalLocation=logicalLocation)

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

            if isNotDuplicateLogicalLocation(logicalLocation, logicalLocationsList):
                logicalLocationsList.append(logicalLocation)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Conkas", version="1.0.0", rules=rulesList,
                                         information_uri="https://github.com/nveloso/conkas",
                                         full_description=MultiformatMessageString(
                                             text="Conkas is based on symbolic execution, determines which inputs cause which program branches to execute, to find potential security vulnerabilities. Conkas uses rattle to lift bytecode to a high level representation.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Ethor)
