#!/bin/sh

FILENAME="$1"
BIN="$2"

cd /conkas
CMD="python3 conkas.py -fav $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
