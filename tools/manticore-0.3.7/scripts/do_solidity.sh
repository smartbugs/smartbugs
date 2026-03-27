#!/bin/sh

FILENAME="$1"
BIN="$2"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

mkdir /results

for c in `python3 "$BIN/printContractNames.py" "${FILENAME}"`; do 
        echo manticore --no-colors --contract "${c}" "${FILENAME#/}" >> $BIN/log
        manticore --no-colors --contract "${c}" "${FILENAME#/}"
        mv /mcore_* /results
done
