#!/bin/bash

RUNID="curated"
PROCESSES=112
TIMEOUT=1800

# Reentrancy
./smartbugs -t ccc -f dataset/reentrancy/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
