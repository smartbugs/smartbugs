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
        OPT_CONTRACT="--target-contracts $CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 80%
    # the remaining 20% are for Oyente to finish
    TO=$(( (TIMEOUT*8+9)/10 ))
    OPT_TIMEOUT="-glt $TO"
fi

cd /oyente
/oyente/oyente/oyente.py $OPT_TIMEOUT -s "$FILENAME" $OPT_CONTRACT
