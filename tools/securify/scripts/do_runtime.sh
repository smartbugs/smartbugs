#!/bin/sh

FILENAME="$1"
BIN="$2"

mkdir /results
java -Xmx16G -jar /securify_jar/securify.jar --livestatusfile /results/live.json --output /results/results.json -fh "$FILENAME"
