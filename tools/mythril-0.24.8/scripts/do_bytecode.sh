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

CMD="/usr/local/bin/myth analyze $OPT_TIMEOUT -o json -f $FILENAME"
echo "$CMD" >> $BIN/log
$CMD

