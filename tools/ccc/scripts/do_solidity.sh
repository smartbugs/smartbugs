#!/bin/sh

# Copyright (c) 2024, Fraunhofer AISEC. All rights reserved.

# in ../config.yaml,
# - set "bin" to "scripts" to add the scripts directory to the mounted volume
# - set "solidity.entrypoint" to "'$BIN/do_solidity.sh' '$FILENAME'"

# full path to file (within docker container) to analyse, e.g. /sb/my_contract.sol
FILENAME="$1"

# Startup Neo4j
neo4j start
STATUS=$(curl --write-out "%{http_code}\n" --silent --output /dev/null http://localhost:7474)
while [ "$STATUS" -ne 200 ]
do
    sleep 1
    STATUS=$(curl --write-out "%{http_code}\n" --silent --output /dev/null http://localhost:7474)
    if [ "$STATUS" -eq 200 ]; then
        echo "Neo4j is running."
    else
        echo "Neo4j is not running."
    fi
done

# Run analysis with CCC
cpg-contract-checker-app "$FILENAME"
