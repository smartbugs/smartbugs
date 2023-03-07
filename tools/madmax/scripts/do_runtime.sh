#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"

OPT_TIMEOUT=""
if [ "$TIMEOUT" -ge 170 ]; then
    # reserve 50s for MaxMax to finish after timeout
    TO=$((TIMEOUT-50))
    OPT_TIMEOUT="-T $TO"
fi

cd /MadMax
python3 gigahorse-toolchain/gigahorse.py --reuse_datalog_bin --rerun_clients --restart $OPT_TIMEOUT -C madmax.dl "${FILENAME}"
