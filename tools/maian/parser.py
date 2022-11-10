import sb.parse_utils
import re

VERSION = "2022/08/05"

FINDINGS = (
    'No Ether leak (no send)',
    'Ether leak',
    'Ether leak (verified)',
    'Accepts Ether',
    'No Ether lock (Ether refused)',
    'Ether lock (Ether accepted without send)',
    'Ether lock',
    'Not destructible (no self-destruct)',
    'Destructible',
    'Destructible (verified)',
)


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
TRANSACTION         = re.compile("    -Tx\[.+\] :([0-9a-z ]+)")

MAP_FINDINGS = (
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


def empty_check():
    return {
        'type': None,
        'file': '',
        'contract': '',
        'errors': set(),
        'findings': set(),
        'exploit': [],
        'notes': set()
    }


def is_empty_check(check):
    return all( not v for v in check.values() )


def parse(exit_code, log, output, task):
    findings, infos, analysis = set(), set(), None
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    if fails:
        errors.discard("EXIT_CODE_1") # redundant

    # first pass: one entry per check
    checks = []
    check  = empty_check()
    deployed = True
    for line in sb.parse_utils.discard_ANSI(log):

        if line.startswith('='*100):
            if not is_empty_check(check) and deployed:
                checks.append(check)
            check = empty_check()
            deployed = True
            continue

        if line.startswith(CANNOT_DEPLOY):
            deployed = False
            continue

        found = False
        for indicator,finding in MAP_FINDINGS:
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

        if sb.parse_utils.add_match(check['errors'], line, ERRORS):
            continue

        m = CHECK.match(line)
        if m:
            check['type'] = m[1]
            continue

        m = FILE.match(line)
        if m:
            check['file'] = m[1]
            continue

        m = MISSING_ABI_BIN.match(line)
        if m:
            assert m[1]==m[2]
            check['contract'] = m[1]
            continue

        m = ADDRESS_SAVED.match(line)
        if m:
            check['contract'] = m[2]
            continue

        m = TRANSACTION.match(line)
        if m:
            check['exploit'].append(m[1])
            continue

    if not is_empty_check(check) and deployed:
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
    analysis = list(contracts.values())
    for result in analysis:
        checks_complete = True
        for t in ("PRODIGAL", "GREEDY", "SUICIDAL"):
            if t not in result:
                checks_complete = False
            else:
                findings.update(result[t]["findings"])
                errors.update(result[t]["errors"])
        if not checks_complete:
            infos.add("analysis incomplete")

    if "analysis incomplete" in infos and not fails and not errors:
        fails.add('execution failed')

    return findings, infos, errors, fails, analysis
