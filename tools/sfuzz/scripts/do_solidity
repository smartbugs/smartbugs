#!/bin/bash

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

CONTRACT="${FILENAME%.sol}"
CONTRACT="${CONTRACT##*/}"
CONTRACTS=$(python3 "$BIN"/printContractNames.py "$FILENAME")
COUNT=$(echo $CONTRACTS | wc -w)
[ "$COUNT" -gt 0 ] || COUNT=1

if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        CONTRACTS="$CONTRACT"
        COUNT=1
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

mkdir -p /home/contracts

for CONTRACT in $CONTRACTS; do
  echo "Extract contract $CONTRACT from $FILENAME"
  cp "$FILENAME" "/home/contracts/$CONTRACT.sol"
done

echo "Extracted $COUNT contract(s) from $FILENAME"

# Fuzz each contract at least 10 seconds
TO=$(((TIMEOUT - (2 * COUNT)) / COUNT))
if [ "$TIMEOUT" -eq 0 ] || [ $TO -lt 10 ]; then
  TO=120
fi
 
cd /home/ && ./fuzzer -g -r 1 -d $TO && chmod +x fuzzMe && ./fuzzMe
