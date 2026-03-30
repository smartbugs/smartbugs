#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 80%
    # the remaining 20% are for osiris to finish
    TO=$(( (TIMEOUT*8+9)/10 ))
    OPT_TIMEOUT="-glt $TO"
fi

CMD="python osiris/osiris.py $OPT_TIMEOUT -b -s $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
