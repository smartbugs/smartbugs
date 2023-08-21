import sb.parse_utils, sb.cfg# for sb.parse_utils.init(...) 
import re

VERSION: str = "2023/08/21"

FINDINGS = [
    "unnecessary-checked-arithmetic-in-loop",
    "proxy-storage-collision",
    "erc20-public-burn",
    "non-payable-constructor",
    "use-prefix-increment-not-postfix",
    "balancer-readonly-reentrancy-getrate",
    "erc777-reentrancy",
    "use-short-revert-string",
    "init-variables-with-default-value",
    "unrestricted-transferownership",
    "erc20-public-transfer",
    "openzeppelin-ecdsa-recover-malleable",
    "erc721-reentrancy",
    "erc677-reentrancy",
    "array-length-outside-loop",
    "no-slippage-check",
    "basic-arithmetic-underflow",
    "oracle-price-update-not-restricted",
    "use-multiple-require",
    "compound-borrowfresh-reentrancy",
    "use-prefix-decrement-not-postfix",
    "use-nested-if",
    "gearbox-tokens-path-confusion",
    "redacted-cartel-custom-approval-bug",
    "erc721-arbitrary-transferfrom",
    "balancer-readonly-reentrancy-getpooltokens",
    "incorrect-use-of-blockhash",
    "curve-readonly-reentrancy",
    "sense-missing-oracle-access-control",
    "encode-packed-collision",
    "uniswap-callback-not-protected",
    "keeper-network-oracle-manipulation",
    "tecra-coin-burnfrom-bug",
    "use-ownable2step",
    "state-variable-read-in-a-loop",
    "use-abi-encodecall-instead-of-encodewithselector",
    "delegatecall-to-arbitrary-address",
    "arbitrary-low-level-call",
    "superfluid-ctx-injection",
    "non-optimal-variables-swap",
    "use-custom-error-not-require",
    "inefficient-state-variable-increment",
    "compound-sweeptoken-not-restricted",
    "accessible-selfdestruct",
    "no-bidi-characters",
    "basic-oracle-manipulation",
    "msg-value-multicall",
    "rigoblock-missing-access-control"
]

def message_lines(log_iterator):
    message_lines = []
    while True:
        next_line = next(log_iterator, '').strip()
        if not next_line:
            break
        message_lines.append(next_line)
    return ' '.join(message_lines)

def parse(exit_code, log, output):
    
    findings, infos = [], set()
    finding = {}
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    log_iterator = iter(log)
    

    
    for line in log_iterator:

        line = line.strip()

        # if line.startswith('/'):
        #     filename = line.split("/")
        #     filename = '/'.join(filename[-2:])
        #     finding = {'filename': filename}

        if re.search(r'solidity\.(performance|best-practice|security)\.', line):
            match = re.search(r'solidity\.(performance|best-practice|security)\.(\S+)', line)
            category = match.group(1)
            name = match.group(2)
            finding['name'] = name
            finding['category'] = category
            finding['message'] = message_lines(log_iterator)

            
        elif re.search(r'\d+┆', line):
            line_location = line.strip().split('┆', 1)
            if len(line_location) > 0:
                cline_number = int(line_location[0])
                finding['line'] = cline_number
        
            findings.append(finding.copy())

    
    return findings, infos, errors, fails
        
        
