#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 80%
    # the remaining 20% are for mythril to finish
    TO=$(( (TIMEOUT*8+9)/10 ))
    OPT_TIMEOUT="--execution-timeout $TO"
fi

echo /usr/local/bin/myth analyze $OPT_TIMEOUT -o json --bin-runtime -f "$FILENAME" >> $BIN/log
/usr/local/bin/myth analyze $OPT_TIMEOUT -o json --bin-runtime -f "$FILENAME"
