#!/bin/sh

# in config.yaml,
# - set "entrypoint" to "'$BIN/do_solidity' '$FILENAME'"
# - set "bin" to "scripts" to add the scripts directory to the mounted volume

FILENAME="$1"
# full path of file (within docker container) to analyse, e.g. /sb/my_contract.sol

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
