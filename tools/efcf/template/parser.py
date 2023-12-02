import yaml

VERSION = "2023/06/09"

FINDINGS = {
    "Reentrancy",
    "Unprotected Selfdestruct",
}

def parse(log):
    findings = []
    errors, fails = [], []

    try:
        # Convert log into dictionary
        log_data = yaml.safe_load(log)

        for tx in log_data['txs']:
            if 'returns' in tx:
                for return_data in tx['returns']:
                    if return_data['reenter']:
                        finding = dict()

                        finding['name'] = 'Reentrancy'
                        finding['input'] = tx['input']
                        finding['return_value'] = return_data['value']
                        finding['return_data'] = return_data['data']

                        findings.append(finding)

            if 'input' in tx and tx['input'].startswith("0x"): # assuming that 0x is the marker of a selfdestruct call
                finding = dict()

                finding['name'] = 'Unprotected Selfdestruct'
                finding['input'] = tx['input']
                finding['length'] = tx['length']
                finding['sender_select'] = tx['sender_select']

                findings.append(finding)

    except Exception as e:
        fails.append(f"error parsing results: {e}")

    return findings, errors, fails

# Read the log file
with open('attack.efcf.yml', 'r') as file:
    log = file.read()

# Parse the log and print the findings
findings, errors, fails = parse(log)
print(findings, errors, fails)
