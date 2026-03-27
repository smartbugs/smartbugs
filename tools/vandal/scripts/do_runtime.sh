#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

mkdir -p /results
cd /results
echo /vandal/bin/analyze.sh "$FILENAME" /vandal/datalog/demo_analyses.dl >> $BIN/log
/vandal/bin/analyze.sh "$FILENAME" /vandal/datalog/demo_analyses.dl
echo 'du -s *.csv | grep -v ^0' >> $BIN/log
du -s *.csv | grep -v ^0
