#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"

export PATH="$BIN:$PATH"
chmod +x "$BIN/solc"

# inform solcx (used by mythril) about the compiler
# by linking the compiler to the place where solcx looks for it
SOLC_VERSION=$(
    "$BIN/solc" --version |
    sed -n 's/^Version: \([0-9][0-9.]*\).*/\1/p' |
    head -n 1
)

if [ -z "$SOLC_VERSION" ]; then
    echo "Cannot determine supplied solc version" >&2
    exit 127
fi

export SOLCX_BINARY_PATH="/tmp/.solcx"
mkdir -p "$SOLCX_BINARY_PATH"
ln -sf "$BIN/solc" "$SOLCX_BINARY_PATH/solc-v$SOLC_VERSION"

# get root of filename in case it is the name of the contract to analyse
CONTRACT="${FILENAME%.sol}"
CONTRACT="${CONTRACT##*/}"
# get the names of all contracts in the source
CONTRACTS=$(python3 "$BIN"/printContractNames.py "$FILENAME")

# if option --main is specified, restrict analysis to $CONTRACT
OPT_CONTRACT=""
if [ "$MAIN" -eq 1 ]; then
    if (echo "$CONTRACTS" | grep -q "$CONTRACT"); then
        OPT_CONTRACT=":$CONTRACT"
    else
        echo "Contract '$CONTRACT' not found in $FILENAME"
        exit 127
    fi
fi

OPT_TIMEOUT=""
if [ "$TIMEOUT" -gt 0 ]; then
    # TO = TIMEOUT * 90%
    # the remaining 10% are for mythril to finish
    TO=$(( (TIMEOUT*9+9)/10 ))
    OPT_TIMEOUT="--execution-timeout $TO"
fi

CMD="/usr/local/bin/myth analyze $OPT_TIMEOUT -o json $FILENAME$OPT_CONTRACT"
echo "$CMD" >> $BIN/log
$CMD
