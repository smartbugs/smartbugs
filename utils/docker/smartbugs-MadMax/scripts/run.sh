#!/bin/sh

FILENAME=$1
CODE=$(cat ${FILENAME})

python3 gigahorse-toolchain/gigahorse.py -C madmax.dl ${FILENAME}
