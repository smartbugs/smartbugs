#!/bin/bash

FILTER=filters

function error {
        echo $1
        exit 1
}

test "$#" -eq 2 || error "Usage: $0 RESULTS1 RESULTS2"

A="$1"
B="$2"

echo "=== CONTRACTS ONLY in $A"
both=()
for c1 in `find "$A" -maxdepth 2 -mindepth 2 -type d` ; do
	c=$(echo $c1 | sed 's=.*/\([^/]*/[^/]*\)$=\1=')
	c2="$B/$c"
	if [ -e "$c2" ]; then
		both+=($c)
	else
		echo $c
	fi
done

echo
echo "=== CONTRACTS ONLY in $B"
for c2 in `find "$B" -maxdepth 2 -mindepth 2 -type d`; do
	c=$(echo $c2 | sed 's=.*/\([^/]*/[^/]*\)$=\1=')
	c1="$A/$c"
	if [ ! -e "$c1" ]; then
		echo $c
	fi
done

echo
echo "=== COMPARING COMMON CONTRACTS"

function filter {
	file="$(echo ""$1""|sed 's=^.*/\([^/]*\)/[^/]*/\./\([^/]*\)\.\([^./]*\)$=\1-\2-\3=')"
	if [ -x "$FILTER/$file" ]; then
		"$FILTER/$file" "$1" "$2"
		return
	fi
	file="$(echo ""$1""|sed 's=^.*/\([^/]*\)/[^/]*/\./\([^/]*\)\.\([^./]*\)$=\2-\3=')"
	if [ -x "$FILTER/$file" ]; then
		"$FILTER/$file" "$1" "$2"
		return
	fi
	cp "$1" "$2"
}

function do_contract {
	filesA=`cd $1;find . -type f`
	filesB=`cd $2;find . -type f`
	c_both=()
	echo "Only in $1:"
	for f in $filesA; do
		if (echo "$filesB" | fgrep -q "$f"); then
			c_both+=($f)
		else
			echo "   $f"
		fi	
	done
	echo "Only in $2:"
        for f in $filesB; do
                if (echo "$filesA" | fgrep -q "$f"); then
                        :
                else
			echo "   $f"
                fi
	done
	echo "Both:"
	for f in ${c_both[@]}; do
		echo ">>> diff $1/$f $2/$f"
		filter $1/$f /tmp/A
		filter $2/$f /tmp/B
		diff /tmp/A /tmp/B
	done
}

for c in ${both[@]}; do
	echo
	echo "--- $c -----------------------------------------"
	do_contract "$A/$c" "$B/$c"
done
