#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

echo slither "$FILENAME" --json /output.json >> $BIN/log
slither "$FILENAME" --json /output.json
