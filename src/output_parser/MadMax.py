if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation

FINDINGS = ( "OverflowLoopIterator", "UnboundedMassOp", "WalletGriefing" )

class MadMax(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        if 'Traceback' in output:
            self._errors.add('exception occurred')
        if 'Writing results to results.json' not in output:
            self._errors.add('analysis incomplete')
        analysis = {}
        for line in self._lines:
            if ': ' in line:
                kv = line.strip().split(': ')
                analysis[kv[0]] = kv[1]
        self._analysis = [ analysis ]
        for f in FINDINGS:
            if f in analysis and analysis[f] != '0.00%':
                self._findings.add(f)
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="MadMax", version="6e9a6e9", rules=rulesList,
                                         information_uri="https://github.com/nevillegrech/MadMax/",
                                         full_description=MultiformatMessageString(
                                             text="Madmax consists of a series of analyses and queries that find gas-focussed vulnerabilities in Ethereum smart contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(MadMax)
