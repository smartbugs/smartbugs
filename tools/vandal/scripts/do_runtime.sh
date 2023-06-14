#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

mkdir -p /results
cd /results
/vandal/bin/analyze.sh "$FILENAME" /vandal/datalog/demo_analyses.dl
du -s *.csv | grep -v ^0
