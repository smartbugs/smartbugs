#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"
BIN="$3"
MAIN="$4"

chmod +x "$BIN/solc"

# Extract Solidity compiler version with error checking
if ! SOLC_OUTPUT=$("$BIN/solc" --version); then
    echo "Error: Failed to execute solc" >&2
    exit 1
fi
SOLC_VERSION=$(echo "$SOLC_OUTPUT" | grep "Version:" | sed -E 's/Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/')
if [ -z "$SOLC_VERSION" ]; then
    echo "Error: Failed to extract solc version" >&2
    exit 1
fi

# Only set SOLC_BIN if version doesn't start with 0.8
# This is due to avoid issue Invalid solc compilation Error: "Invalid option to --combined-json: compact-format which does not"
# happen with the bundled 0.8 version of solc
case "$SOLC_VERSION" in
    0.8*)
        echo "Solidity version $SOLC_VERSION detected, skipping SOLC_BIN export"
        ;;
    *)
        export SOLC_BIN="$BIN/solc"
        ;;
esac

/app/inference.sh $FILENAME -b access_control,arithmetic,denial_of_service,front_running,reentrancy,time_manipulation,unchecked_low_level_calls -t $TIMEOUT
