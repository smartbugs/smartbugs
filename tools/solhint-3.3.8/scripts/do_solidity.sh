#!/bin/sh

FILENAME="$1"
BIN="$2"

#export PATH="$BIN:$PATH"
#chmod +x "$BIN/solc"

echo solhint -f unix "$FILENAME" >> $BIN/log
solhint -f unix "$FILENAME"
