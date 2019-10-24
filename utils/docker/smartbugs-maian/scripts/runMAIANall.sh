#!/bin/sh

FILENAME=$1

for c in `python3 printContractNames.py ${FILENAME}`; 
do 
        cd /MAIAN/tool; 
        python maian.py -c 0 -s ${FILENAME} ${c};
        python maian.py -c 1 -s ${FILENAME} ${c};
        python maian.py -c 2 -s ${FILENAME} ${c}
done
