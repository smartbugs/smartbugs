#!/bin/sh

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

OPT_CONTRACT=""
if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        COUNT=1
        OPT_CONTRACT="--contract $CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

# Fuzz each contract at least 10 seconds
OPT_TIMEOUT=""
TO=$(((TIMEOUT - (10 * COUNT)) / COUNT))
if [ "$TIMEOUT" -gt 0 ] && [ $TO -ge 10 ]; then
    OPT_TIMEOUT="--timeout $TO"
fi

touch /root/results.json
python3 fuzzer/main.py -s "$FILENAME" --evm byzantium --results results.json --seed 1427655 $OPT_TIMEOUT $OPT_CONTRACT
