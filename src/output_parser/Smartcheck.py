if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import *
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseArtifact, parseRule, parseResult, parseLogicalLocation


class Smartcheck(Parser):

    @staticmethod
    def extract_result_line(line):
        index_split = line.index(":")
        key = line[:index_split]
        value = line[index_split + 1:].strip()
        if value.isdigit():
            value = int(value)
        return (key, value)

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._analysis = []
        current_error = None
        for line in self._lines:
            if "ruleId: " in line:
                if current_error is not None:
                    self._analysis.append(current_error)
                current_error = {
                    'name': line[line.index("ruleId: ") + 8:]
                }
            elif current_error is not None and ':' in line and ' :' not in line:
                (key, value) = Smartcheck.extract_result_line(line)
                current_error[key] = value
        if current_error is not None:
            self._analysis.append(current_error)
        for e in self._analysis:
            self._findings.add(e['name'])

    def parseSarif(self, smartcheck_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        artifact = parseArtifact(uri=file_path_in_repo)

        for analysis in smartcheck_output_results["analysis"]:
            rule = parseRule(tool="smartcheck", vulnerability=analysis["name"])
            result = parseResult(tool="smartcheck", vulnerability=analysis["name"], level=analysis["severity"],
                                 uri=file_path_in_repo,
                                 line=analysis["line"], column=analysis["column"], snippet=analysis["content"])

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

        logicalLocation = parseLogicalLocation(name=smartcheck_output_results["contract"])

        tool = Tool(driver=ToolComponent(name="SmartCheck", version="0.0.12", rules=rulesList,
                                         information_uri="https://tool.smartdec.net/",
                                         full_description=MultiformatMessageString(
                                             text="Securify automatically checks for vulnerabilities and bad coding practices. It runs lexical and syntactical analysis on Solidity source code.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=[logicalLocation], results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Smartcheck)

