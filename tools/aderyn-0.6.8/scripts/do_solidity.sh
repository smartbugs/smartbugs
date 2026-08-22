#!/bin/sh

FILENAME="$1"
TIMEOUT="$2"  
BIN="$3"   

ROOT=$(dirname "$FILENAME")   
BASENAME=$(basename "$FILENAME")

# Bridge: put SmartBugs' injected solc where Aderyn looks for it
# Aderyn has no --solc flag; it resolves the version from the pragma and expects the
# compiler in $HOME/.svm/<ver>/solc-<ver>. We pre-seed that path with the injected solc
# so Aderyn uses SmartBugs' compiler and never hits the network (runs stay offline).
if [ -f "$BIN/solc" ]; then
    chmod +x "$BIN/solc"
    VER=$("$BIN/solc" --version 2>/dev/null | \
          sed -n 's/.*Version: \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
    if [ -n "$VER" ]; then
        mkdir -p "$HOME/.svm/$VER"
        cp "$BIN/solc" "$HOME/.svm/$VER/solc-$VER"
        chmod +x "$HOME/.svm/$VER/solc-$VER"
    fi
fi

# Run Aderyn on just the target contract, JSON report to the collected path
aderyn "$ROOT" -i "$BASENAME" -o /output.json --skip-update-check
