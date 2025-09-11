#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"

CMD="python3 /app/main/main.py --contract $FILENAME --filetype bytecode --model-dir models --instance-len 10 --report /app/output.pdf"

echo "Executing $CMD"
$CMD