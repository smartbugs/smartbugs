#!/bin/sh

FILENAME=$1

for c in `python3 printContractNames.py ${FILENAME} | grep -v "ANTLR runtime and generated code versions disagree:"`; 
do 
        cd /MAIAN/tool; 
        python3 maian.py -c 0 -s ${FILENAME} ${c};
        python3 maian.py -c 1 -s ${FILENAME} ${c};
        python3 maian.py -c 2 -s ${FILENAME} ${c}
done
