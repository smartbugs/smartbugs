#!/bin/sh

FILENAME="$1"
BIN="$2"
MAIN="$3"

export PATH="$BIN:$PATH"
chmod +x $BIN/solc

CONTRACT="${FILENAME%.sol}"
CONTRACT="${CONTRACT##*/}"
CONTRACTS=$(python3 "$BIN"/printContractNames.py "$FILENAME")

OPT_CONTRACT=""
if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        OPT_CONTRACT="--contract $CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

cd /conkas
python3 conkas.py -fav -s "$FILENAME" $OPT_CONTRACT
