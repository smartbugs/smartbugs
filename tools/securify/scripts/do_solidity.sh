#!/bin/sh

FILENAME="$1"
BIN="$2"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

mkdir /results
echo java -Xmx16G -jar /securify_jar/securify.jar --livestatusfile /results/live.json --output /results/results.json -fs "$FILENAME" >> $BIN/log
java -Xmx16G -jar /securify_jar/securify.jar --livestatusfile /results/live.json --output /results/results.json -fs "$FILENAME"
