#!/bin/sh

FILENAME="$1"
BIN="$2"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

mkdir /results

for c in `python3 "$BIN/printContractNames.py" "${FILENAME}"`; do 
        CMD="manticore --no-colors --contract ${c} ${FILENAME#/}"
	echo "$CMD" >> $BIN/log
	$CMD
        mv /mcore_* /results
done
