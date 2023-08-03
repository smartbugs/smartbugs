#!/bin/sh

FILENAME="$1"
CONTRACT="${FILENAME%.sol}"
CONTRACT="${CONTRACT##*/}"
CONTRACTS=$(python3 "$BIN"/printContractNames.py "$FILENAME")

docker run -v ~/Smartbugs/tools/ilf_test:/go/src/ilf/ --platform linux/x86_64 -it ilf
mkdir -p /tba_contracts
cd /tba_contracts
mkdir -p /tba_contracts/"$CONTRACT"
cd /tba_contracts/"$CONTRACT"
truffle init
cp ./"$CONTRACT"/ /tba_contracts/"$CONTRACT"/contracts/
python3 script/extract.py --proj tba_contracts/"$FILENAME"/ --port 8545`

