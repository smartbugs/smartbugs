#!/bin/sh

FILENAME="$1"
BIN="$2"

cd /MAIAN/tool

for c in 0 1 2; do
    CMD="python3 maian.py -c $c -bs $FILENAME"
    echo "$CMD" >> $BIN/log
    $CMD
done
