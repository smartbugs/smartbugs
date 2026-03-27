#!/bin/sh

FILENAME="$1"
BIN="$2"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

echo securify "$FILENAME" >> $BIN/log
securify "$FILENAME"
