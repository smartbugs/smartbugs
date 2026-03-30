#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

export PYTHONPATH=/home/slither/.local/lib/python3.10/site-packages

CMD="slither $FILENAME --json /output.json"
echo "$CMD" >> $BIN/log
$CMD
