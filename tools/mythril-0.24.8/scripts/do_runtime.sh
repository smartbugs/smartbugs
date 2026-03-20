#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 90%
    # the remaining 10% are for mythril to finish
    TO=$(( (TIMEOUT*9+9)/10 ))
    OPT_TIMEOUT="--execution-timeout $TO"
fi

echo /usr/local/bin/myth analyze $OPT_TIMEOUT -o json --bin-runtime -f "$FILENAME" >> $BIN/log

/usr/local/bin/myth analyze $OPT_TIMEOUT -o json --bin-runtime -f "$FILENAME"

