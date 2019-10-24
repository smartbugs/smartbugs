#!/bin/sh

FILENAME=$1

mkdir /results
for c in `python3 printContractNames.py ${FILENAME}`; 
do 
        path_contract=$(echo "$1" | sed -e 's/^\///')
        manticore --no-colors --contract ${c} $path_contract
        mv /mcore_* /results
done
