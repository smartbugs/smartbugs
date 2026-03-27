#!/bin/sh

FILENAME="$1"
BIN="$2"

cd /MAIAN/tool

echo python3 maian.py -c 0 -b "$FILENAME" >> $BIN/log
python3 maian.py -c 0 -b "$FILENAME"

echo python3 maian.py -c 1 -b "$FILENAME" >> $BIN/log
python3 maian.py -c 1 -b "$FILENAME"

echo python3 maian.py -c 2 -b "$FILENAME" >> $BIN/log
python3 maian.py -c 2 -b "$FILENAME"
