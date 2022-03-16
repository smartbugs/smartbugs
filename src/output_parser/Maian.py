if __name__ == '__main__':
    import sys
    sys.path.append("../..")


import re
from sarif_om import *
from src.output_parser.Parser import Parser, python_errors
from src.execution.execution_task import Execution_Task
from src.output_parser.SarifHolder import parseRule, parseResult, parseArtifact

FILE                = re.compile('\[ \] Compiling Solidity contract from the file .*/(.*) \.\.\.')
MISSING_ABI_BIN     = re.compile('\[-\] Some of the files is missing or empty: \|(.*)\.abi\|=[0-9]+  \|(.*)\.bin\|=[0-9]+')
ADDRESS_SAVED       = re.compile('\[ \] Contract address saved in file: (.*/)?(.*)\.address')
CANNOT_DEPLOY       = '[-] Cannot deploy the contract' # no bincode, e.g. interfaces in the source code
NOT_PRODIGAL        = '[+] The code does not have CALL/SUICIDE, hence it is not prodigal'
LEAK_FOUND          = '[-] Leak vulnerability found!'
#CANNOT_CONFIRM_BUG  = '[-] Cannot confirm the bug because the contract is not deployed on the blockchain.'
#CANNOT_CONFIRM_LEAK = '[ ] Confirming leak vulnerability on private chain ...     Cannot confirm the leak vulnerability'
PRODIGAL_CONFIRMED  = '    Confirmed ! The contract is prodigal !'
#PRODIGAL_NOT_FOUND  = '[+] No prodigal vulnerability found'
CAN_RECEIVE_ETHER   = '[+] Contract can receive Ether'
CANNOT_RECEIVE_ETHER= '[-] No lock vulnerability found because the contract cannot receive Ether'
IS_GREEDY           = '[-] The code does not have CALL/SUICIDE/DELEGATECALL/CALLCODE thus is greedy !'
#NO_LOCKING_FOUND    = '[+] No locking vulnerability found'
LOCK_FOUND          = '[-] Locking vulnerability found!'
NO_SELFDESTRUCT     = '[-] The code does not contain SUICIDE instructions, hence it is not vulnerable'
SD_VULN_FOUND       = '[-] Suicidal vulnerability found!'
#CANNOT_CONFIRM_BUG  = '[-] Cannot confirm the bug because the contract is not deployed on the blockchain.' # already defined above
#CANNOT_CONFIRM_SDV  = '[ ] Confirming suicide vulnerability on private chain ...     Cannot confirm the suicide vulnerability'
SD_VULN_CONFIRMED   = '    Confirmed ! The contract is suicidal !'
#SD_VULN_NOT_FOUND   = '[-] No suicidal vulnerability found'

FINDINGS = (
    (NOT_PRODIGAL, 'No Ether leak (no send)'),
    (LEAK_FOUND, 'Ether leak'),
    (PRODIGAL_CONFIRMED, 'Ether leak (verified)'),
#    (PRODIGAL_NOT_FOUND , 'No Ether leak found'), # nothing detected
    (CAN_RECEIVE_ETHER, 'Accepts Ether'),
    (CANNOT_RECEIVE_ETHER, 'No Ether lock (Ether refused)'),
    (IS_GREEDY, 'Ether lock (Ether accepted without send)'),
#    (NO_LOCKING_FOUND, 'No Ether lock found'), # nothing detected
    (LOCK_FOUND, 'Ether lock'),
    (NO_SELFDESTRUCT, 'Not destructible (no self-destruct)'),
    (SD_VULN_FOUND, 'Destructible'),
    (SD_VULN_CONFIRMED, 'Destructible (verified)'),
#    (SD_VULN_NOT_FOUND, 'No destructibility found'), # nothing detected
)

ERRORS = (
    re.compile('\[-\] (Cannot compile the contract)'),
    re.compile('.*(Unknown operation)'),
    re.compile('.*(Some addresses are larger)'),
    re.compile('.*(did not process.*)'),
    re.compile('.*(In SLOAD the list at address)'),
    re.compile('.*(Incorrect final stack size)'),
    re.compile('.*(need to set the parameters)'),
    re.compile('\[-\] (.* does NOT exist)'),
    re.compile('.*Exception: (.*)'),
)

CHECK = re.compile('\[ \] Check if contract is (PRODIGAL|GREEDY|SUICIDAL)')

class Maian(Parser):

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if output is None or not output:
            self._errors.add('output missing')
            return
        self._errors.update(python_errors(output))
        (self._analysis, self._findings, errors) = Maian.__parse(self._lines)
        self._errors.update(errors)

    @staticmethod
    def __empty_check():
        return {'file': '', 'contract': '', 'errors': set(), 'findings': set()}

    @staticmethod
    def __is_empty_check(check):
        return len(check) == 4 and not check['file'] and not check['contract'] and not check['errors'] and not check['findings']

    @staticmethod
    def __parse(lines):
        # first pass: one entry per check
        checks = []
        check  = Maian.__empty_check()
        deployed = True
        for line in lines:
            if line.startswith('='*100):
                if not Maian.__is_empty_check(check) and deployed:
                    checks.append(check)
                check = Maian.__empty_check()
                deployed = True
            if line.startswith(CANNOT_DEPLOY):
                deployed = False
            for indicator,finding in FINDINGS:
                if line.startswith(indicator):
                    check['findings'].add(finding)
            for ERROR in ERRORS:
                if m := ERROR.match(line):
                    check['errors'].add(m[1])
            if m := CHECK.match(line):
                check['type'] = m[1]
            if m := FILE.match(line):
                check['file'] = m[1]
            if m := MISSING_ABI_BIN.match(line):
                assert m[1]==m[2]
                check['contract'] = m[1]
            if m := ADDRESS_SAVED.match(line):
                check['contract'] = m[2]
        if not Maian.__is_empty_check(check) and deployed:
            checks.append(check)
        # second pass: one entry per contract, with findings, errors, and checks merged
        contracts = {}
        for check in checks:
            key = (check['file'], check['contract'])
            if key not in contracts:
                contracts[key] = {'findings': set(), 'errors': set(), 'checks': set()}
            if 'type' in check:
                contracts[key]['checks'].add(check['type'])
            contracts[key]['errors'].update(check['errors'])
            contracts[key]['findings'].update(check['findings'])
        # third pass: convert dict to list, test for completeness of checks,
        # collect errors and findings
        analysis = []
        errors = set()
        findings = set()
        for key,contract in contracts.items():
            f,c = key
            es = contract['errors']
            fs = contract['findings'] 
            if len(contract['checks']) < 3:
                es.add('checks incomplete')
            analysis.append({
                'file': f,
                'contract': c,
                'findings': sorted(fs),
                'errors': sorted(es)
            })
            findings.update(fs)
            errors.update(es)
        return (analysis, findings, errors)

    def parseSarif(self, maian_output_results, file_path_in_repo):
        resultsList = []
        rulesList = []

        # TODO: loop probably doesn't work anymore, as maian_output_results["analysis"] has changed
        for vulnerability in maian_output_results["analysis"].keys():
            if maian_output_results["analysis"][vulnerability]:
                rule = parseRule(tool="maian", vulnerability=vulnerability)
                result = parseResult(tool="maian", vulnerability=vulnerability, level="error",
                                     uri=file_path_in_repo)

                rulesList.append(rule)
                resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Maian", version="5.10", rules=rulesList,
                                         information_uri="https://github.com/ivicanikolicsg/MAIAN",
                                         full_description=MultiformatMessageString(
                                             text="Maian is a tool for automatic detection of buggy Ethereum smart contracts of three different types prodigal, suicidal and greedy.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run


if __name__ == '__main__':
    import Parser
    Parser.main(Maian)
