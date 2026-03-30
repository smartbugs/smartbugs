#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

#export PATH="$BIN:$PATH"
#chmod +x "$BIN/solc"

CMD="solhint -f unix -q $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
