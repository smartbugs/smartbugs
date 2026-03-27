#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

echo semgrep --config ./solidity "$FILENAME" >> $BIN/log
semgrep --config ./solidity "$FILENAME" 
