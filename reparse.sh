#!/bin/bash

if [ "$#" -ne 2 ]; then
	cat <<END
Usage:   $0 <directory tree containing result.log> <parser to use>
	 Re-parses each result.log in the directory tree, generating result.new.json.
         If result.json exists, it is used to initialize result.new.json.
Example: $0 smartbugs/results/vandal Vandal
END
	exit 1
fi

DIR="$1"
PARSERS="src/output_parser"
PARSER="$PARSERS/$2.py"

if [ ! -d "$DIR" ]; then
	echo "$DIR does not exist"
	exit 1
fi

if [ ! -f "$PARSER" ]; then
	echo "$PARSER not found"
	exit 1
fi

cd "$PARSERS"
source ../../venv/bin/activate
for LOG in `find "$DIR" -name result.log`; do
	echo "$LOG"
	JSON=${LOG%.log}.json
	JSONNEW=${LOG%.log}.new.json
	if [ -f "$JSONNEW" ]; then
		echo "$JSONNEW already exists, skipping $LOG"
		continue
	fi
	if [ -f "$JSON" ]; then
		python "$PARSER" "$LOG" "$JSON" > "$JSONNEW"
	else
		python "$PARSER" "$LOG" > "$JSONNEW"
	fi
done
