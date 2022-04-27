#!/bin/sh

URL=$1
FILENAME=$2

export WEB3_PROVIDER_URI="$1"
cat ${FILENAME} | pakala - --exec-timeout 1500 --analysis-timeout 300
