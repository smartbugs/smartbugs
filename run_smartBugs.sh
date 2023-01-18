#!/bin/bash

DATASET="dataset/**/*.sol"
RUNID="curated"
PROCESSES=112
TIMEOUT=1800

# ConFuzzius
./smartbugs -t confuzzius -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/confuzzius:4315fb7

# Conkas
./smartbugs -t conkas -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/conkas:latest

# Ethainter

# eThor

# HoneyBadger
./smartbugs -t honeybadger -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/honeybadger:latest

# MadMax

# Maian
./smartbugs -t maian -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/maian:solc5.10

# Manticore
./smartbugs -t manticore -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/manticore:0.3.7

# Mythril
./smartbugs -t mythril -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/mythril:0.23.5

# Osiris
./smartbugs -t osiris -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/osiris:latest

# Oyente
./smartbugs -t oyente -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/oyente:480e725

# Pakala

# Securify
./smartbugs -t securify -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/security:usolc

# Slither
./smartbugs -t slither -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/slither:latest

# Smartcheck
./smartbugs -t smartcheck -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/smartcheck:latest

# Solhint
./smartbugs -t solhint -f $DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/solhint:latest

# teEther

# Vandal
