#!/bin/sh

FILENAME="$1"
BIN="$2"

mkdir /results

CMD="java -Xmx16G -jar /securify_jar/securify.jar --livestatusfile /results/live.json --output /results/results.json -fh $FILENAME"
echo "$CMD" >> $BIN/log
$CMD
