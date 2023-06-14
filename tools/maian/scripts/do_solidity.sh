#!/bin/sh

FILENAME="$1"
BIN="$2"
MAIN="$3"

export PATH="$BIN:$PATH"
chmod +x $BIN/solc

CONTRACT="${FILENAME%.sol}"
CONTRACT="${CONTRACT##*/}"
CONTRACTS=$(python3 "$BIN"/printContractNames.py "$FILENAME")

if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        CONTRACTS="$CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

cd /MAIAN/tool; 
for CONTRACT in $CONTRACTS; do
    for c in 0 1 2; do
        python3 maian.py -c "$c" -s "$FILENAME" "$CONTRACT"
    done
done
