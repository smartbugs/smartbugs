#!/bin/bash
source ../venv/bin/activate

function error {
	echo $1
	exit 1
}

function headline {
	echo
	echo "=== $1 ==="
	echo
}

[ -d results ] && error "'results' already exists, remove it to rerun $0"
#[ -d dataset ] && error "'dataset' already exists, remove it to test the solidiFI download"
[ -d ../dataset/solidiFI ] && error "'../dataset/solidiFI' already exists, remove it to test the solidiFI download"

headline 'single file, all tools, output: json+sarif (aggregated)'
python ../smartBugs.py -t all -f samples/1/timed_crowdsale.sol --execution-name file --processes 10 --aggregate-sarif

headline 'directory, smartcheck, output: json'
python ../smartBugs.py -t smartcheck -f samples/10 --execution-name dir --processes 10 --output-version v1

headline 'local dataset, osiris, output: sarif'
python ../smartBugs.py  -t osiris -d access_control --execution-name local --processes 10 --output-version v2

headline 'remote dataset, solhint, output: sarif (single file)'
python ../smartBugs.py -t solhint -d solidiFI/tx_origin --execution-name remote --processes 10 --output-version v2 --unique-sarif-output

headline 'diff   coverage=reference data   results=this data'
diff -r coverage results | less

