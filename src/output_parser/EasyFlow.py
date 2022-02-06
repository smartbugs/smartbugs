if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


KEYS = (
        ('input:', 'input'),
        ('result:', 'result'),
        ('Coverage:', 'coverage')
)

class EasyFlow(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        analysis = {
            'errors': []
        }
        if 'Traceback' in output:
            analysis['errors'].append('exception occurred')
        for line in self._lines:
            for indicator,key in KEYS:
                if indicator in line:
                    analysis[key] = line.split(indicator)[1].strip()
                    break
        self._analysis = [analysis]
        if 'result' in analysis:
            self._findings.add(analysis['result'])
        for e in analysis['errors']:
            self._errors.add(e)
    
    def parseSarif(self, output_results, file_path_in_repo):
        resultsList = []
        logicalLocationsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="EasyFlow", version="c7a34b6", rules=rulesList,
                                         information_uri="https://github.com/Jianbo-Gao/EasyFlow/",
                                         full_description=MultiformatMessageString(
                                             text="EasyFlow is a prototype of overflow detection tool for Ethereum smart contracts.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=logicalLocationsList, results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Easyflow)
