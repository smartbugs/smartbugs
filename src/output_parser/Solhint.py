if __name__ == '__main__':
    import sys
    sys.path.append("../..")


from sarif_om import *
from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import isNotDuplicateRule, parseRule, parseResult, parseArtifact, parseLogicalLocation


class Solhint(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._analysis = []
        for line in self._lines:
            if ":" in line:
                s_result = line.split(':')
                if len(s_result) != 4:
                    continue
                (file, line, column, end_error) = s_result
                if ']' not in end_error:
                    continue
                message = end_error[1:end_error.index('[') - 1]
                level = end_error[end_error.index('[') + 1: end_error.index('/')]
                type = end_error[end_error.index('/') + 1: len(end_error) - 1]
                self._analysis.append({
                    'file': file,
                    'line': line,
                    'column': column,
                    'message': message,
                    'level': level,
                    'type': type
                })
                self._findings.append(type)

    def parseSarif(self, solhint_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        for analysis in solhint_output_results["analysis"]:
            rule = parseRule(tool="solhint", vulnerability=analysis["type"], full_description=analysis["message"])
            result = parseResult(tool="solhint", vulnerability=analysis["type"], level=analysis["level"],
                                 uri=file_path_in_repo, line=int(analysis["line"]), column=int(analysis["column"]))

            resultsList.append(result)

            if isNotDuplicateRule(rule, rulesList):
                rulesList.append(rule)

        artifact = parseArtifact(uri=file_path_in_repo)

        logicalLocation = parseLogicalLocation(name=solhint_output_results["contract"], kind="contract")

        tool = Tool(driver=ToolComponent(name="Solhint", version="3.3.2", rules=rulesList,
                                         information_uri="https://protofire.github.io/solhint/",
                                         full_description=MultiformatMessageString(
                                             text="Open source project for linting solidity code. This project provide both security and style guide validations.")))

        run = Run(tool=tool, artifacts=[artifact], logical_locations=[logicalLocation], results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Solhint)
