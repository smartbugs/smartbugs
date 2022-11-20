import sb.parse_utils
import re

VERSION = "2022/11/11"

FINDINGS = (
    "No Ether leak (no send)",
    "Ether leak",
    "Ether leak (verified)",
#    "Accepts Ether",
    "No Ether lock (Ether refused)",
    "Ether lock (Ether accepted without send)",
    "Ether lock",
    "Not destructible (no self-destruct)",
    "Destructible",
    "Destructible (verified)",
)


FILENAME            = re.compile("\[ \] Compiling Solidity contract from the file (.*/.*) \.\.\.")
MISSING_ABI_BIN     = re.compile("\[-\] Some of the files is missing or empty: \|(.*)\.abi\|=[0-9]+  \|(.*)\.bin\|=[0-9]+")
CONTRACT            = re.compile("\[ \] Contract address saved in file: (?:.*/)?(.*)\.address")
CANNOT_DEPLOY       = "[-] Cannot deploy the contract" # no bincode, e.g. interfaces in the source code
NOT_PRODIGAL        = "[+] The code does not have CALL/SUICIDE, hence it is not prodigal"
LEAK_FOUND          = "[-] Leak vulnerability found!"
CANNOT_CONFIRM_BUG  = "[-] Cannot confirm the bug because the contract is not deployed on the blockchain."
CANNOT_CONFIRM_LEAK = "[ ] Confirming leak vulnerability on private chain ...     Cannot confirm the leak vulnerability"
PRODIGAL_CONFIRMED  = "    Confirmed ! The contract is prodigal !"
PRODIGAL_NOT_FOUND  = "[+] No prodigal vulnerability found"
CAN_RECEIVE_ETHER   = "[+] Contract can receive Ether"
CANNOT_RECEIVE_ETHER= "[-] No lock vulnerability found because the contract cannot receive Ether"
IS_GREEDY           = "[-] The code does not have CALL/SUICIDE/DELEGATECALL/CALLCODE thus is greedy !"
NO_LOCKING_FOUND    = "[+] No locking vulnerability found"
LOCK_FOUND          = "[-] Locking vulnerability found!"
NO_SELFDESTRUCT     = "[-] The code does not contain SUICIDE instructions, hence it is not vulnerable"
SD_VULN_FOUND       = "[-] Suicidal vulnerability found!"
CANNOT_CONFIRM_SDV  = "[ ] Confirming suicide vulnerability on private chain ...     Cannot confirm the suicide vulnerability"
SD_VULN_CONFIRMED   = "    Confirmed ! The contract is suicidal !"
SD_VULN_NOT_FOUND   = "[-] No suicidal vulnerability found"
TRANSACTION         = re.compile("    -Tx\[.+\] :([0-9a-z ]+)")

MAP_FINDINGS = (
    (NOT_PRODIGAL, "No Ether leak (no send)"),
    (LEAK_FOUND, "Ether leak"),
    (PRODIGAL_CONFIRMED, "Ether leak (verified)"),
#    (CAN_RECEIVE_ETHER, "Accepts Ether"),
    (CANNOT_RECEIVE_ETHER, "No Ether lock (Ether refused)"),
    (IS_GREEDY, "Ether lock (Ether accepted without send)"),
    (LOCK_FOUND, "Ether lock"),
    (NO_SELFDESTRUCT, "Not destructible (no self-destruct)"),
    (SD_VULN_FOUND, "Destructible"),
    (SD_VULN_CONFIRMED, "Destructible (verified)"),
)

INFOS = (
#    (PRODIGAL_NOT_FOUND , "No Ether leak found"), # nothing detected
#    (NO_LOCKING_FOUND, "No Ether lock found"), # nothing detected
#    (SD_VULN_NOT_FOUND, "No destructibility found"), # nothing detected
    (CANNOT_CONFIRM_BUG, "Cannot confirm vulnerability because contract not deployed on blockchain"),
    (CANNOT_CONFIRM_LEAK, "Cannot confirm vulnerability because contract not deployed on blockchain"),
    (CANNOT_CONFIRM_SDV, "Cannot confirm vulnerability because contract not deployed on blockchain"),
)

ERRORS = (
    re.compile("\[-\] (Cannot compile the contract)"),
    re.compile(".*(Unknown operation)"),
    re.compile(".*(Some addresses are larger)"),
    re.compile(".*(did not process.*)"),
    re.compile(".*(In SLOAD the list at address)"),
    re.compile(".*(Incorrect final stack size)"),
    re.compile(".*(need to set the parameters)"),
    re.compile("\[-\] (.* does NOT exist)"),
    re.compile(".*(?<!Z3)Exception: (.{,64})"),
)

CHECK = re.compile("\[ \] Check if contract is (PRODIGAL|GREEDY|SUICIDAL)")


def parse(exit_code, log, output):
    findings, infos = [], set()
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    if fails:
        errors.discard("EXIT_CODE_1") # redundant

    analysis_complete = {}
    finding = {}
    for line in sb.parse_utils.discard_ANSI(log):
        if line.startswith("="*100):
            if finding.get("name"):
                findings.append(finding)
            finding = {}
            continue

        m = FILENAME.match(line)
        if m:
            finding["filename"] = m[1]
            continue

        m = CONTRACT.match(line)
        if m and finding.get("filename"):
            finding["contract"] = m[1]
            continue

        m = MISSING_ABI_BIN.match(line)
        if m:
            assert m[1]==m[2]
            finding["contract"] = m[1]
            continue

        found = False
        for indicator,name in MAP_FINDINGS:
            if line.startswith(indicator):
                finding["name"] = name
                found = True
                break
        if found:
            continue

        found = False
        for indicator,info in INFOS:
            if line.startswith(indicator):
                infos.add(info)
                found = True
                break
        if found:
            continue

        if sb.parse_utils.add_match(errors, line, ERRORS):
            continue

        m = CHECK.match(line)
        if m:
            k = (finding.get("filename"),finding.get("contract"))
            if k not in analysis_complete:
                analysis_complete[k] = set()
            analysis_complete[k].add(m[1])
            continue

        m = TRANSACTION.match(line)
        if m:
            if "exploit" not in finding:
                finding["exploit"] = []
            finding["exploit"].append(m[1])
            continue
    if finding.get("name"):
        findings.append(finding)

    for checks in analysis_complete.values():
        if len(checks) != 3:
            infos.add("analysis incomplete")
            if not fails and not errors:
                fails.add("execution failed")

    return findings, infos, errors, fails
