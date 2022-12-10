#!/bin/bash

rm -rf results
smartbugs -t all -f 'samples/simple_dao.*' --runid github --json
./results2csv -x start duration -- results \
    | sed 's/,Transaction_Order_Dependency//' \
    > .github/results-ubuntu.csv
