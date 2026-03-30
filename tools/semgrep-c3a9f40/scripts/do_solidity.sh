#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

CMD="semgrep --config ./solidity $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
