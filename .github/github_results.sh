#!/bin/bash

rm -rf results/github
./smartbugs -t all -f 'samples/simple_dao.*' --runid github --json
./results2csv -x start duration -- results/*/github \
    | sed 's/,Transaction_Order_Dependency//' \
    > .github/results-ubuntu.csv
