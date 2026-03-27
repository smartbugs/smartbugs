#!/bin/sh

FILENAME="$1"
BIN="$2"

cd /MAIAN/tool

echo python3 maian.py -c 0 -bs "$FILENAME" >> $BIN/log
python3 maian.py -c 0 -bs "$FILENAME"

echo python3 maian.py -c 1 -bs "$FILENAME" >> $BIN/log
python3 maian.py -c 1 -bs "$FILENAME"

echo python3 maian.py -c 2 -bs "$FILENAME" >> $BIN/log
python3 maian.py -c 2 -bs "$FILENAME"
