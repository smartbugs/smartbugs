#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"

# export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"
export SOLC_BIN="$BIN/solc"

# Extract Solidity compiler version with error checking
if ! SOLC_OUTPUT=$("$BIN/solc" --version); then
    echo "Error: Failed to execute solc" >&2
    exit 1
fi
SOLC_VERSION=$(echo "$SOLC_OUTPUT" | grep "Version:" | sed -E 's/Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
if [ -z "$SOLC_VERSION" ]; then
    echo "Error: Failed to extract solc version" >&2
    exit 1
fi

# To decrease runtime, add parameter --detectors with a comma-separated list of detectors with the following possible values:
#   reentrancy-eth,controlled-array-length,suicidal,controlled-delegatecall,arbitrary-send,incorrect-equality,integer-overflow,unchecked-lowlevel,tx-origin,locked-ether,unchecked-send,costly-loop,erc721-interface,erc20-interface,timestamp,block-other-parameters,calls-loop,low-level-calls,erc20-indexed,erc20-throw,hardcoded,array-instead-bytes,unused-state,costly-operations-loop,external-function,send-transfer,boolean-equal,boolean-cst,uninitialized-state,tod
CMD="python3 /app/main/main.py --contract $FILENAME --solc-version $SOLC_VERSION --filetype solidity --model-dir models --instance-len 20 --report /app/output.pdf"

echo "Executing $CMD"
$CMD