import sb.parse_utils, sb.cfg# for sb.parse_utils.init(...) 
import re

VERSION: str = "2023/06/12"

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

# def parse_file(file):
    # findings = []
    # for i, line in enumerate(file):
    #     # analyse stdout/stderr of the Docker run
        
    #     line = line.strip()

    #     if line.startswith('/'):
    #         current_finding = {'filename': line}
    #     elif 'solidity.performance.' in line:
    #         name = line.split('solidity.performance.')[1].split(' ')[0]
    #         message = file[i+1].strip()
    #         current_finding= {
    #             **current_finding,
    #             'name': name,
    #             'message': message
    #         }
            
    #     elif re.search(r'\d+┆', line):
    #         line_location = line.strip().split('┆', 1)
    #         if len(line_location) > 0:
    #             cline_number = int(line_location[0])
    #             current_finding = {
    #             **current_finding,
    #             'line': cline_number
    #             }
        
    #         findings.append(current_finding.copy())
    # return findings


def parse(exit_code, log, output):
    
    findings, infos = [], set()
    finding = {}
    errors, fails = sb.parse_utils.errors_fails(exit_code, log)
    # Parses the output for common Python/Java/shell exceptions (returned in 'fails')
    # file = sb.cfg.TOOL_LOG
    # print(log)

    for line in log:

        line = line.strip()

        if line.startswith('/'):
            finding = {'filename': line}
            print(finding["filename"])
        elif 'solidity.performance.' in line:
            finding = {'name': line.split('solidity.performance.')[1].split(' ')[0]}
            # finding = {'message' : line[1+i].strip()}
            print(finding["name"])
        elif 'solidity.best-practice.' in line:
            name = line.split('solidity.best-practice.')[1].split(' ')[0]
            finding = {'name': name}
        elif 'solidity.security.' in line:
            name = line.split('solidity.security.')[1].split(' ')[0]
            finding = {'name': name}
            
            
        elif re.search(r'\d+┆', line):
            line_location = line.strip().split('┆', 1)
            if len(line_location) > 0:
                cline_number = int(line_location[0])
                finding['line'] = cline_number
        
            findings.append(finding.copy())

    # file = sb.cfg.TASK_LOG
    
    return findings, infos, errors, fails
        
        


    # try:
    #     with io.BytesIO(output) as o, tarfile.open(fileobj=o) as tar:

    #         # access specific file
    #         contents_of_some_file = tar.extractfile("name_of_some_file").read()

    #         # iterate over all files:
    #         for f in tar.getmembers():
    #             contents_of_f = tar.extractfile(f).read()
    # except Exception as e:
    #     fails.add(f"error parsing results: {e}")

