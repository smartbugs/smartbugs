#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

semgrep --config ./solidity "$FILENAME" 
