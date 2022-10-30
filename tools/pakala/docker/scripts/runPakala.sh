#!/bin/sh

FILENAME="$1"

geth --dev --http --http.api eth,web3,personal,net &
sleep 2

export WEB3_PROVIDER_URI="http://127.0.0.1:8545"
cat "$FILENAME" | pakala - --exec-timeout 1500 --analysis-timeout 300
