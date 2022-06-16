#!/bin/bash

overwrite_newjson="false"
overwrite_json="false"

while :; do
	case "$1" in
		-f)
			shift
			overwrite_newjson="true"
			;;
		-F)
			shift
			overwrite_json="true"
			overwrite_newjson="true"
			;;
		*)
			break
			;;
	esac
done


if [ "$#" -ne 2 ]; then
	cat <<END
Usage:   $0 OPTIONS <directory tree containing result.log> <parser to use>
	 Parses all result.log files into files named result.new.json.
         Uses an existing result.json to initialize result.new.json.
         Skips result.log, if result.new.json already exists.
Example: $0 smartbugs/results/vandal Vandal
Options: -f Overwrite an existing result.new.json
         -F Overwrite an existing result.new.json, and rename it to result.json
END
	exit 1
fi


DIR="$1"
PARSER="$2.py"

if [ ! -d "$DIR" ]; then
	echo "$DIR does not exist"
	exit 1
fi

cd src/output_parser
case "$DIR" in
	/*) : ;;
	*) DIR="../../$DIR" ;;
esac

if [ ! -f "$PARSER" ]; then
	echo "$PARSER not found"
	exit 1
fi

source ../../venv/bin/activate
for d in `find "$DIR" -name 'result.*' | sed 's"/result\..*""' | sort -u`; do
	echo "$d"
	LOG="${d}/result.log"
	JSON="${d}/result.json"
	JSONNEW="${d}/result.new.json"
	if [ "$overwrite_newjson" = "false" -a -f "$JSONNEW" ]; then
		echo "$JSONNEW already exists, skipping $LOG"
		continue
	fi
	if [ -f "$JSON" ]; then
		python "$PARSER" "$LOG" "$JSON" > "$JSONNEW"
	else
		python "$PARSER" "$LOG" > "$JSONNEW"
	fi
	if [ "$overwrite_json" = "true" -a -f "$JSONNEW" ]; then
		mv -f "$JSONNEW" "$JSON"
	fi
done
