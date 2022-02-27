if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import os,tarfile,json
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
from src.output_parser.Parser import Parser, python_errors
from src.output_parser.SarifHolder import parseRule, parseResult, isNotDuplicateRule, parseArtifact, parseLogicalLocation, isNotDuplicateLogicalLocation


FINDINGS = (
    # MadMax
    "OverflowLoopIterator", "UnboundedMassOp", "WalletGriefing",
    # Ethainter
    "AccessibleSelfdestruct", "TaintedOwnerVariable",
    "TaintedSelfdestruct", "TaintedDelegatecall",
    "TaintedStoreIndex", "UncheckedTaintedStaticcall",
    "TaintedValueSend",
)

class Gigahorse(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(output))
        if 'Writing results to results.json' not in output:
            self._errors.add('analysis incomplete')
        result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
        try:
            with tarfile.open(result_tar, 'r') as tar:
                try:
                    output_file = tar.extractfile('results.json')
                except Exception as e:
                    self._errors.add(f'problem extracting results.json from {result_tar}')
                    return
                try:
                    self._analysis = json.loads(output_file.read())
                except Exception as e:
                    self._errors.add(f'problem loading json file results.json')
                    print(traceback.format_exception(type(e), e, e.__traceback__))
                    return
        except Exception as e:
            self._errors.add(f'problem opening tar archive {result_tar}')
            return
        try:
            for contract in self._analysis:
                self._errors.update(contract[2])
                results = contract[3]
                for finding in FINDINGS:
                    if finding in results and results[finding]:
                        self._findings.add(finding)
        except Exception as e:
            self._errors.add(f'problem accessing findings in results.json')
            return
    

if __name__ == '__main__':
    import Parser
    Parser.main(Gigahorse)
