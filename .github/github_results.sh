#!/bin/bash

# Run .github/github_results.sh from SmartBugs home directory
# Generates .github/results-ubuntu.csv, needed for the workflow ubuntu.yml
# as a reference for comparing the results of the workflow with

#rm -rf results/*/github-sol
./smartbugs -t all -f 'samples/SimpleDAO.sol' --runid github-sol --sarif --main --timeout 180
./results2csv -x start duration -- results/*/github-sol | sed '/confuzzius/s/".*"//' > .github/results-ubuntu-sol.csv

#rm -rf results/*/github-rt
./smartbugs -t all -f 'samples/SimpleDAO.rt.hex' --runid github-rt --sarif --timeout 180
./results2csv -x start duration -- results/*/github-rt > .github/results-ubuntu-rt.csv

#rm -rf results/*/github-hx
./smartbugs -t all -f 'samples/SimpleDAO.hex' --runid github-hx --sarif --timeout 180
./results2csv -x start duration -- results/*/github-hx > .github/results-ubuntu-hx.csv
