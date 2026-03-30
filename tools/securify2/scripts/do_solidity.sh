#!/bin/sh

FILENAME="$1"
BIN="$2"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

CMD="securify $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
