"""
MAIAN CI test runner for Augur project.
"""
import argparse
import json
import os
import pprint
import re
import shutil

from subprocess import check_output

fail_build = False  # Specifies if to fail the build


def check_failure(test_result):
    """
    Return True if a failure was found.

    :param test_result: test result log.
    :return: True if failure found, false otherwise.
    """
    fail_regexes = ["Confirmed ! The contract is suicidal !",
                    "Confirmed ! The contract is prodigal !",
                    "Leak vulnerability found!",
                    "Locking vulnerability found!",
                    "The code does not have CALL/SUICIDE/DELEGATECALL/CALLCODE thus is greedy !"]
    for fail_regex in fail_regexes:
        if re.search(fail_regex, test_result, re.IGNORECASE):
            return True
    return False


def setup_blockchain(maian_blockchain_dir="/MAIAN/tool/blockchains"):
    """
    Setup private blockchain for the project.

    :param maian_blockchain_dir: path to MAIAN blockchain dir
    :return: -
    """
    if os.path.exists(os.path.join(os.getcwd(), 'blockchains')):
        shutil.rmtree(os.path.join(os.getcwd(), 'blockchains'))
    shutil.copytree(maian_blockchain_dir, os.path.join(os.getcwd(), 'blockchains'))


def run_maian(contract_bytecode_path, mode):
    """
    Run MAIAN tool.

    :param contract_bytecode_path: path to bin contract file
    :param mode: 0 - search for suicidal contracts, 1 - prodigal, 2 - greedy.
    :return: True if vulnerability found. False otherwise.
    """
    vulnerability_found = False
    result = check_output(['python',
                           '/MAIAN/tool/maian.py',
                           '-b',
                           contract_bytecode_path,
                           '-c',
                           mode]).decode("utf-8")
    print(result)

    if check_failure(result):
        vulnerability_found = True

    return vulnerability_found


def extract_augur_contracts_for_analysis(contracts_file_path=
                                         '/app/output/contracts/contracts.json'):
    """
    Extract Augur contracts from contracts.json

    :param contracts_file_path: full path to contracts.json
    :return: a list of paths to files with contracts bytecode
    :rtype: list
    """
    contract_list = []
    with open(contracts_file_path) as f:
        contracts = json.load(f)['contracts']
    for contract_filename in contracts.keys():
        contract_name = contracts[contract_filename].keys()[0]
        contract_bytecode = contracts[contract_filename][contract_name]['evm']['bytecode']['object']
        print("Extracting " + contract_filename + "...")
        if os.path.exists(os.path.join(os.getcwd(), contract_filename)):
            os.remove(os.path.join(os.getcwd(), contract_filename))
        try:
            os.makedirs(os.path.join(os.getcwd(), os.path.dirname(contract_filename)))
        except os.error:
            pass  # folder already exists
        contract_bytecode_path = os.path.join(os.path.dirname(contract_filename), contract_name + '.bin')
        with open(contract_bytecode_path, 'w') as wf:
            wf.write(contract_bytecode)
            print("Contract bytecode written to " + contract_bytecode_path)
            contract_list.append(contract_bytecode_path)
    return contract_list


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--fail-on-vulnerability",
                        help="Return a non-zero exit code if a vulnerability is found",
                        action="store_true",
                        default=False)
    args = parser.parse_args()

    setup_blockchain()

    suicidal = []
    prodigal = []
    greedy = []

    # Process each file individually and check for suicidal, prodigal and greedy contracts
    for file in extract_augur_contracts_for_analysis():

        print("Processing " + file + " for suicidal contracts\n")
        if run_maian(file, '0'):
            suicidal.append(file)
            if args.fail_on_vulnerability:
                fail_build = True

        print("Processing " + file + " for prodigal contracts\n")
        if run_maian(file, '1'):
            prodigal.append(file)
            if args.fail_on_vulnerability:
                fail_build = True

        print("Processing " + file + " for greedy contracts\n")
        if run_maian(file, '2'):
            greedy.append(file)
            if args.fail_on_vulnerability:
                fail_build = True

    print("#" * 60)
    print("MAIAN test results summary:")
    print("Suicidal contracts:")
    pprint.pprint([c.encode("utf-8") for c in sorted(suicidal)])
    print("Prodigal contracts:")
    pprint.pprint([c.encode("utf-8") for c in sorted(prodigal)])
    print("Greedy contracts:")
    pprint.pprint([c.encode("utf-8") for c in sorted(greedy)])

    if fail_build:
        exit(1)
