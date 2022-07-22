import os,tarfile,json
import src.output_parser.Parser as Parser
from sarif_om import Tool, ToolComponent, MultiformatMessageString, Run
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

class Gigahorse(Parser.Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return
        self._fails.update(Parser.exceptions(self._lines))
        if 'Writing results to results.json' not in output:
            self._messages.add('analysis incomplete')
            if not self._fails and not self._errors:
                self._fails.add('execution failed')
        #if ' timed out' in output: # Redundant, will also be reported in result.tar
        #    self._errors.add('timed out')

        result_tar = os.path.join(self._task.result_output_path(), 'result.tar')
        try:
            with tarfile.open(result_tar, 'r') as tar:
                try:
                    output_file = tar.extractfile('results.json')
                except Exception as e:
                    self._fails.add(f'problem extracting results.json from {result_tar}')
                    return
                try:
                    self._analysis = json.loads(output_file.read())
                except Exception as e:
                    self._fails.add(f'problem loading json file results.json')
                    return
        except Exception as e:
            self._fails.add(f'problem opening tar archive {result_tar}')
            return
        try:
            for contract in self._analysis:
                self._errors.update(contract[2])
                results = contract[3]
                for finding in FINDINGS:
                    if finding in results and results[finding]:
                        self._findings.add(finding)
        except Exception as e:
            self._fails.add(f'problem accessing findings in results.json')
            return
