#!/bin/bash

RUNS=runs

function error {
	echo $1
	exit 1
}

test "$#" -eq 3 -o "$#" -eq 2 || error "Usage: $0 CMD DATADIR [COMMIT]"

CMD="$1"
test -x "$CMD" || error "$CMD is not an executable"

SET="$2"
test -d "$SET" || error "$SET is not a directory"

COMMIT="$3"

if [ "$COMMIT" ]; then
	RUN="$RUNS/${CMD##*/}-${SET##*/}-${COMMIT:0:7}"
else
	RUN="$RUNS/${CMD##*/}-${SET##*/}"
fi
test ! -d "$RUN" || error "$RUN already exists, nothing to do"
test ! -e "$RUN" || error "$RUN already exists, but is not a directory!?"

if [ "$COMMIT" ]; then
	git checkout "$COMMIT" || exit 1
fi
"$CMD" "$SET"
if [ "$COMMIT" ]; then
	git switch - || exit 1
fi

test -d results && mv results "$RUN"
echo "For the results, see $RUN"

cd "$RUN"
mv logs/* .
rmdir logs
for d in */*; do
	if [ -d "$d" ]; then
		mv $d/* ${d%/*}
		rmdir $d
	fi
done
