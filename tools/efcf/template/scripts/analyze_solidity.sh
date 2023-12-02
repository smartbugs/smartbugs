#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"

if [ "$TIMEOUT" -eq 0 ]; then
    efcfuzz --quiet --print-progress --cores 4 --source "$FILENAME"
else
    # TO = TIMEOUT * 80%
    # the remaining 20% are for efcf to finish
    TO=$(( (TIMEOUT*8+9)/10 ))
    efcfuzz --quiet --print-progress --cores 4 --timeout "$TO" --source "$FILENAME"
fi
