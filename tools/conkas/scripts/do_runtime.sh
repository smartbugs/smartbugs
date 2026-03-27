#!/bin/sh

FILENAME="$1"
BIN="$2"

cd /conkas
echo python3 conkas.py -fav "$FILENAME" >> $BIN/log
python3 conkas.py -fav "$FILENAME"
