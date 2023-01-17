#!/bin/bash

DATASET="dataset/*/*.sol"
RUNID="curated"
PROCESSES=112
TIMEOUT=1800

# ConFuzzius
./smartbugs -t confuzzius -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Conkas
./smartbugs -t conkas -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Ethainter

# eThor

# HoneyBadger
./smartbugs -t honeybadger -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# MadMax

# Maian
./smartbugs -t maian -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Manticore
./smartbugs -t manticore -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Mythril
./smartbugs -t mythril -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Osiris
./smartbugs -t osiris -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Oyente
./smartbugs -t oyente -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Pakala

# Securify
./smartbugs -t securify -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Slither
./smartbugs -t slither -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Smartcheck
./smartbugs -t smartcheck -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Solhint
./smartbugs -t solhint -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# teEther

# Vandal
