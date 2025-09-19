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

OPT_CONTRACT=""
if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        OPT_CONTRACT=":$CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 80%
    # the remaining 20% are for mythril to finish
    TO=$(( (TIMEOUT*8+9)/10 ))
    OPT_TIMEOUT="--execution-timeout $TO"
fi

/usr/local/bin/myth analyze $OPT_TIMEOUT -o json "$FILENAME$OPT_CONTRACT"
