#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
SB=$(dirname "$FILENAME")

OPT_TIMEOUT=""
if [ "$TIMEOUT" -ge 170 ]; then
    # reserve 50s for Ethainter to finish after timeout
    TO=$((TIMEOUT-50))
    OPT_TIMEOUT="-T $TO"
fi

echo cd /home/reviewer/gigahorse-toolchain/logic >> $BIN/log
cd /home/reviewer/gigahorse-toolchain/logic

echo ./analyze.py --reuse_datalog_bin --restart --rerun_clients $OPT_TIMEOUT -d "$SB" -C ../../ethainter-inlined.dl >> $BIN/log
./analyze.py --reuse_datalog_bin --restart --rerun_clients $OPT_TIMEOUT -d "$SB" -C ../../ethainter-inlined.dl
