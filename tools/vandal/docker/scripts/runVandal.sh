#!/bin/sh

FILENAME=$1

mkdir -p results; cd results; /vandal/bin/analyze.sh ${FILENAME} /vandal/datalog/demo_analyses.dl; du -s *.csv | grep -v ^0
