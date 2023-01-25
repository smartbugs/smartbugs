#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import shutil
import subprocess

from web3 import Web3

PROVIDER = Web3.HTTPProvider("https://mainnet.infura.io/v3/59bd984e502449f081d26eba3c624a32")

class colors:
    INFO = "\033[94m"
    OK = "\033[92m"
    FAIL = "\033[91m"
    END = "\033[0m"

def main(folder):
    w3 = Web3(PROVIDER)
    for path, subdirs, files in os.walk(folder):
        for name in files:
            if not os.path.exists(os.path.join(path, name.replace(".sol", ".rt.hex"))):
                print(os.path.join(path, name))
                runtime = ""
                if name.startswith("0x") and len(name.replace(".sol", "")) == 42:
                    address = Web3.toChecksumAddress(name.replace(".sol", ""))
                    runtime = w3.eth.get_code(address).hex().replace("0x", "")
                    if runtime != "":
                        print("Retrieved runtime bytecode from blockchain for address:", address)
                        with open(os.path.join(path, name.replace(".sol", ".rt.hex")), "w") as f:
                            f.write(runtime)
                if runtime == "":
                    if shutil.which("solc-select") is None:
                        print("Please install 'solc-select'")
                        print("")
                        break
                    with open(os.path.join(path, name), "r") as f:
                        source_lines = f.readlines()
                        for line in source_lines:
                            if line.strip().startswith("pragma solidity"):
                                print("Pragma:", line.strip())
                                version = line.strip().replace("pragma solidity", "").replace("^", "").replace(" ", "").replace(";", "")
                                subprocess.run(["solc-select", "install", version])
                                subprocess.run(["solc-select", "use", version])
                                try:
                                    out = subprocess.check_output(["solc", "--bin-runtime", os.path.join(path, name)]).decode("utf-8")
                                    if len(out.split("Binary of the runtime part:")) == 2:
                                        runtime = out.split("Binary of the runtime part:")[1].strip().replace(" ", "")
                                    else:
                                        contracts = out.split("\n\n")
                                        for contract in contracts:
                                            if len(contract.split("Binary of the runtime part:")) == 2:
                                                if len(runtime) < len(contract.split("Binary of the runtime part:")[1].strip().replace(" ", "")):
                                                    runtime = contract.split("Binary of the runtime part:")[1].strip().replace(" ", "")
                                except Exception as e:
                                    if version.startswith("0.4"):
                                        subprocess.run(["solc-select", "install", "0.4.26"])
                                        subprocess.run(["solc-select", "use", "0.4.26"])
                                        try:
                                            out = subprocess.check_output(["solc", "--bin-runtime", os.path.join(path, name)]).decode("utf-8")
                                            if len(out.split("Binary of the runtime part:")) == 2:
                                                runtime = out.split("Binary of the runtime part:")[1].strip().replace(" ", "")
                                            else:
                                                contracts = out.split("\n\n")
                                                for contract in contracts:
                                                    if len(contract.split("Binary of the runtime part:")) == 2:
                                                        if len(runtime) < len(contract.split("Binary of the runtime part:")[1].strip().replace(" ", "")):
                                                            runtime = contract.split("Binary of the runtime part:")[1].strip().replace(" ", "")
                                        except Exception as e:
                                            print(e)
                                            print(colors.FAIL+"Error: Could not compile", os.path.join(path, name), "using solc version", version, colors.END)
                                    else:
                                        print(e)
                                        print(colors.FAIL+"Error: Could not compile", os.path.join(path, name), "using solc version", version, colors.END)
                                if runtime != "":
                                    print("Retrieved runtime bytecode through compilation:", os.path.join(path, name))
                                    with open(os.path.join(path, name.replace(".sol", ".rt.hex")), "w") as f:
                                        f.write(runtime)
                print("")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: {} <DIRECTORY_WITH_SOLIDITY_FILES>".format(sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    main(sys.argv[1])
