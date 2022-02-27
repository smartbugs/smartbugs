#!/bin/sh

FILENAME=$1
CODE=$(cat ${FILENAME})

python3 gigahorse-toolchain/gigahorse.py --reuse_datalog_bin --rerun_clients --restart -C madmax.dl ${FILENAME}
