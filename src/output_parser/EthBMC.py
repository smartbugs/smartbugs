if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


class EthBMC(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None:
            self._errors.add('output missing')
            return
        if 'Finished analysis in' not in output:
            self._errors.add('analysis incomplete')
        if 'stack backtrace:' in output:
            self._errors.add('exception occurred')
        coverage = None
        for line in self._lines:
            if "Code covered: " in line:
                coverage = line.split("Code covered: ")[1]
            if "Found attack, " in line:
                self._findings.add(line.split("Found attack, ")[1])
        analysis = { 'exploit': sorted(self._findings) }
        if coverage is not None:
            analysis['coverage'] = coverage
        self._analysis = [ analysis ]
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="EthBMC", version="60d1b58", rules=rulesList,
                                         information_uri="https://github.com/RUB-SysSec/EthBMC",
                                         full_description=MultiformatMessageString(
                                             text="A Bounded Model Checker for Smart Contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(EthBMC)
