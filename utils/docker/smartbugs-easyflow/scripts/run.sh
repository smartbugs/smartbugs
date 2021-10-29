#!/bin/sh

FILENAME=$1
INPUT=$2
CODE=$(cat ${FILENAME})

cd taint_scripts
python run.py --input ${INPUT} --debug --code ${CODE}
