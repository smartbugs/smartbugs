import re
import src.output_parser.Parser as Parser
from sarif_om import *
from src.execution.execution_task import Execution_Task
from src.output_parser.SarifHolder import parseRule, parseResult, parseArtifact

FILE                = re.compile('\[ \] Compiling Solidity contract from the file .*/(.*) \.\.\.')
MISSING_ABI_BIN     = re.compile('\[-\] Some of the files is missing or empty: \|(.*)\.abi\|=[0-9]+  \|(.*)\.bin\|=[0-9]+')
ADDRESS_SAVED       = re.compile('\[ \] Contract address saved in file: (.*/)?(.*)\.address')
CANNOT_DEPLOY       = '[-] Cannot deploy the contract' # no bincode, e.g. interfaces in the source code
NOT_PRODIGAL        = '[+] The code does not have CALL/SUICIDE, hence it is not prodigal'
LEAK_FOUND          = '[-] Leak vulnerability found!'
CANNOT_CONFIRM_BUG  = '[-] Cannot confirm the bug because the contract is not deployed on the blockchain.'
CANNOT_CONFIRM_LEAK = '[ ] Confirming leak vulnerability on private chain ...     Cannot confirm the leak vulnerability'
PRODIGAL_CONFIRMED  = '    Confirmed ! The contract is prodigal !'
PRODIGAL_NOT_FOUND  = '[+] No prodigal vulnerability found'
CAN_RECEIVE_ETHER   = '[+] Contract can receive Ether'
CANNOT_RECEIVE_ETHER= '[-] No lock vulnerability found because the contract cannot receive Ether'
IS_GREEDY           = '[-] The code does not have CALL/SUICIDE/DELEGATECALL/CALLCODE thus is greedy !'
NO_LOCKING_FOUND    = '[+] No locking vulnerability found'
LOCK_FOUND          = '[-] Locking vulnerability found!'
NO_SELFDESTRUCT     = '[-] The code does not contain SUICIDE instructions, hence it is not vulnerable'
SD_VULN_FOUND       = '[-] Suicidal vulnerability found!'
CANNOT_CONFIRM_SDV  = '[ ] Confirming suicide vulnerability on private chain ...     Cannot confirm the suicide vulnerability'
SD_VULN_CONFIRMED   = '    Confirmed ! The contract is suicidal !'
SD_VULN_NOT_FOUND   = '[-] No suicidal vulnerability found'
TRANSACTION = re.compile("    -Tx\[.+\] :([0-9a-z ]+)")

FINDINGS = (
    (NOT_PRODIGAL, 'No Ether leak (no send)'),
    (LEAK_FOUND, 'Ether leak'),
    (PRODIGAL_CONFIRMED, 'Ether leak (verified)'),
    (CAN_RECEIVE_ETHER, 'Accepts Ether'),
    (CANNOT_RECEIVE_ETHER, 'No Ether lock (Ether refused)'),
    (IS_GREEDY, 'Ether lock (Ether accepted without send)'),
    (LOCK_FOUND, 'Ether lock'),
    (NO_SELFDESTRUCT, 'Not destructible (no self-destruct)'),
    (SD_VULN_FOUND, 'Destructible'),
    (SD_VULN_CONFIRMED, 'Destructible (verified)'),
)

NOTES = (
    (PRODIGAL_NOT_FOUND , 'No Ether leak found'), # nothing detected
    (NO_LOCKING_FOUND, 'No Ether lock found'), # nothing detected
    (SD_VULN_NOT_FOUND, 'No destructibility found'), # nothing detected
    (CANNOT_CONFIRM_BUG, 'Cannot confirm vulnerability because contract not deployed on blockchain'),
    (CANNOT_CONFIRM_LEAK, 'Cannot confirm vulnerability because contract not deployed on blockchain'),
    (CANNOT_CONFIRM_SDV, 'Cannot confirm vulnerability because contract not deployed on blockchain'),
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

class Maian(Parser.Parser):
    NAME = "maian"
    VERSION = "2022/07/22"

    @staticmethod
    def __empty_check():
        return {'type': None, 'file': '', 'contract': '', 'errors': set(), 'findings': set(), 'exploit': [], 'notes': set()}

    @staticmethod
    def __is_empty_check(check):
        for v in check.values():
            if v:
                return False
        return True

    def __init__(self, task: 'Execution_Task', output: str):
        super().__init__(task, output)
        if not self._lines:
            if not self._fails:
                self._fails.add('output missing')
            return

        self._lines = Parser.discard_ANSI(self._lines)

        self._fails.update(Parser.exceptions(self._lines))
        # Remove redundant error
        if self._fails:
            self._errors.discard("EXIT_CODE_1")

        # first pass: one entry per check
        checks = []
        check  = Maian.__empty_check()
        deployed = True
        for line in self._lines:

            if line.startswith('='*100):
                if not Maian.__is_empty_check(check) and deployed:
                    checks.append(check)
                check = Maian.__empty_check()
                deployed = True
                continue

            if line.startswith(CANNOT_DEPLOY):
                deployed = False
                continue

            found = False
            for indicator,finding in FINDINGS:
                if line.startswith(indicator):
                    check['findings'].add(finding)
                    found = True
                    continue
            if found:
                continue

            found = False
            for indicator,note in NOTES:
                if line.startswith(indicator):
                    check['notes'].add(note)
                    found = True
                    continue
            if found:
                continue

            if Parser.add_match(check['errors'], line, ERRORS):
                continue

            if m := CHECK.match(line):
                check['type'] = m[1]
                continue

            if m := FILE.match(line):
                check['file'] = m[1]
                continue

            if m := MISSING_ABI_BIN.match(line):
                assert m[1]==m[2]
                check['contract'] = m[1]
                continue

            if m := ADDRESS_SAVED.match(line):
                check['contract'] = m[2]

            if m := TRANSACTION.match(line):
                check['exploit'].append(m[1])

        if not Maian.__is_empty_check(check) and deployed:
            checks.append(check)

        # second pass: one entry per contract
        contracts = {}
        for check in checks:
            key = (check["file"], check["contract"])
            if key not in contracts:
                contracts[key] = { "file": check["file"], "contract": check["contract"] }
            contracts[key][check["type"]] = {
                "findings": sorted(check["findings"]),
                "errors": sorted(check["errors"]),
                "transactions for exploit": check["exploit"],
                "notes": sorted(check["notes"])
            }

        # third pass: convert dict to list, test for completeness of checks,
        # collect errors and findings
        self._analysis = list(contracts.values())
        for result in self._analysis:
            checks_complete = True
            for t in ("PRODIGAL", "GREEDY", "SUICIDAL"):
                if t not in result:
                    checks_complete = False
                else:
                    self._findings.update(result[t]["findings"])
                    self._errors.update(result[t]["errors"])
            if not checks_complete:
                self._messages.add("analysis incomplete")

        if "analysis incomplete" in self._messages and not self._fails and not self._errors:
            self._fails.add('execution failed')



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
