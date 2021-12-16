from sarif_om import *

from src.output_parser.Parser import Parser
from src.output_parser.SarifHolder import parseRule, \
    parseResult, parseArtifact

import re

#FILE                = re.compile('\[ \] Compiling Solidity contract from the file .*/(.*) \.\.\.')
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

INFOS = (
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
    (SD_VULN_CONFIRMED, 'Destructible (verified)')
#    (SD_VULN_NOT_FOUND, 'No destructibility found') # nothing detected
)

ERRORS = (
    re.compile('\[-\] (Cannot compile the contract)'),
    re.compile('.*(Unknown operation.*)'),
    re.compile('.*(did not process.*)'),
    re.compile('.*(In SLOAD the list at address.*)'),
    re.compile('.*(Incorrect final stack size)'),
    re.compile('.*(need to set the parameters.*)'),
    re.compile('\[-\] (.* does NOT exist)'),
    re.compile('.*Exception: (.*)'),
    re.compile('.*(Traceback) \(most recent call last\):')
)

CHECK = re.compile('\[ \] Check if contract is (PRODIGAL|GREEDY|SUICIDAL)')

VT100 = re.compile('\x1b\[[^m]*m')
PYTHON2_WARNING = 'DeprecationWarning: Python 2 support is ending!'

class Maian(Parser):

    @staticmethod
    def __empty_result():
        return {'contract': '', 'errors': set(), 'findings': set()}

    @staticmethod
    def __is_empty_result(result):
        return len(result) == 3 and not result['contract'] and not result['errors'] and not result['findings']

    @staticmethod
    def __sanitized(lines):
        slines = []
        for line in lines:
            if PYTHON2_WARNING in line:
                continue
            slines.append(VT100.sub('',line))
        return slines

    @staticmethod
    def __parse_output(str_output: str):
        lines = Maian.__sanitized(str_output.splitlines())
        results = []
        result = Maian.__empty_result()
        deployed = True
        for line in lines:
            if line.startswith('='*100):
                if not Maian.__is_empty_result(result) and deployed:
                    results.append(result)
                result = Maian.__empty_result()
                deployed = True
            if line.startswith(CANNOT_DEPLOY):
                deployed = False
            for INFO, finding in INFOS:
                if line.startswith(INFO):
                    result['findings'].add(finding)
            for ERROR in ERRORS:
                if m := ERROR.match(line):
                    result['errors'].add(m[1])
            if m := CHECK.match(line):
                result['check'] = m[1]
            if m := MISSING_ABI_BIN.match(line):
                assert m[1]==m[2]
                result['contract'] = m[1]
            if m := ADDRESS_SAVED.match(line):
                result['contract'] = m[2]
        if not Maian.__is_empty_result(result) and deployed:
            results.append(result)
        analyses = {}
        for result in results:
            contract = result['contract']
            if contract not in analyses:
                analyses[contract] = {'findings': set(), 'errors': set(), 'checks': set()}
            if 'check' in result:
                analyses[contract]['checks'].add(result['check'])
            analyses[contract]['errors'].update(result['errors'])
            analyses[contract]['findings'].update(result['findings'])
        output = {}
        labels = set()
        success = True
        for contract, analysis in analyses.items():
            errors = analysis['errors']
            if len(analysis['checks']) < 3:
                errors.add('Checks incomplete')
            output[contract] = {'findings': sorted(analysis['findings']), 'errors': sorted(errors)}
            labels.update([Parser.str2label(f) for f in analysis['findings']])
            if len(errors) > 0:
                success = False
        return (output, sorted(labels), success)

    def __init__(self, task: 'Execution_Task', str_output: str):
        super().__init__(task, str_output)
        if str_output is None:
            return
        (self.output, self.labels, self.success) = Maian.__parse_output(str_output)

    def parseSarif(self, maian_output_results, file_path_in_repo):
        # maian_output_results obsolete, kept for compatibility
        resultsList = []
        rulesList = []

        # The loop will not work since self.output has changed
        #for vulnerability in self.output.keys():
        #    if maian_output_results["analysis"][vulnerability]:
        #        rule = parseRule(tool="maian", vulnerability=vulnerability)
        #        result = parseResult(tool="maian", vulnerability=vulnerability, level="error",
        #                             uri=file_path_in_repo)

        #        rulesList.append(rule)
        #        resultsList.append(result)

        artifact = parseArtifact(uri=file_path_in_repo)

        tool = Tool(driver=ToolComponent(name="Maian", version="5.10", rules=rulesList,
                                         information_uri="https://github.com/ivicanikolicsg/MAIAN",
                                         full_description=MultiformatMessageString(
                                             text="Maian is a tool for automatic detection of buggy Ethereum smart contracts of three different types prodigal, suicidal and greedy.")))

        run = Run(tool=tool, artifacts=[artifact], results=resultsList)

        return run
