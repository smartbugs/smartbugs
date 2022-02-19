if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import os,re,tarfile
from sarif_om import Tool, ToolComponent, Run, MultiformatMessageString
from src.output_parser.Parser import Parser, python_errors
from src.output_parser.SarifHolder import isNotDuplicateRule, parseArtifact, parseRule, parseResult


class Manticore(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(output))
        if 'Invalid solc compilation' in output:
            self._errors.add('solc error')
        result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
        try:
            with tarfile.open(result_tar, 'r') as tar:
                m = re.findall('Results in /(mcore_.+)', output)
                self._analysis = []
                for fout in m:
                    output_file = tar.extractfile('results/' + fout + '/global.findings')
                    self._analysis.append(Manticore.parseFile(output_file.read().decode('utf8')))
        except Exception as e:
            self._errors.add(f'problem accessing {result_tar}')

    @staticmethod
    def parseFile(content):
        output = []
        lines = content.splitlines()
        current_vul = None
        for line in lines:
            if len(line) == 0:
                continue
            if line[0] == '-':
                if current_vul is not None:
                    output.append(current_vul)
                current_vul = {
                    'name': line[1:-2].strip(),
                    'line': -1,
                    'code': None
                }
            elif current_vul is not None and line[:4] == '    ':
                index = line[4:].rindex('  ') + 4
                current_vul['line'] = int(line[4:index])
                current_vul['code'] = line[index:].strip()

        if current_vul is not None:
            output.append(current_vul)
        return output

    def parseSarif(self, manticore_output_results, file_path_in_repo):
        rulesList = []
        resultsList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        for multipleAnalysis in manticore_output_results["analysis"]:
            for analysis in multipleAnalysis:
                rule = parseRule(tool="manticore", vulnerability=analysis["name"])
                result = parseResult(tool="manticore", vulnerability=analysis["name"], level="warning",
                                     uri=file_path_in_repo,
                                     line=analysis["line"], snippet=analysis["code"])

                resultsList.append(result)

                if isNotDuplicateRule(rule, rulesList):
                    rulesList.append(rule)

        tool = Tool(driver=ToolComponent(name="Manticore", version="0.3.5", rules=rulesList,
                                         information_uri="https://github.com/trailofbits/manticore",
                                         full_description=MultiformatMessageString(
                                             text="Manticore is a symbolic execution tool for analysis of smart contracts and binaries.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Manticore)

