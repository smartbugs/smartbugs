#!/bin/sh

FILENAME="$1"

./analyze.py --reuse_datalog_bin --restart --rerun_clients -d /data -C ../../ethainter-inlined.dl
