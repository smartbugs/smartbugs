#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

cd /MadMax
python3 gigahorse-toolchain/gigahorse.py --reuse_datalog_bin --rerun_clients --restart -C madmax.dl "${FILENAME}"
