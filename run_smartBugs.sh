#!/bin/bash

SOLIDITY_DATASET="dataset/**/*.sol"
RUNTIME_DATASET="dataset/**/*.rt.hex"
RUNID="curated"
PROCESSES=112
TIMEOUT=1800

# ConFuzzius
./smartbugs -t confuzzius -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/confuzzius:4315fb7

# Conkas
./smartbugs -t conkas -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/conkas:latest

# Ethainter
./smartbugs -t ethainter -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/ethainter:latest

# eThor
./smartbugs -t ethor -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/ethor:rmvi20q

# HoneyBadger
./smartbugs -t honeybadger -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/honeybadger:latest

# MadMax
./smartbugs -t madmax -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/madmax:6e9a6e9

# Maian
./smartbugs -t maian -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/maian:solc5.10

# Manticore
./smartbugs -t manticore -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/manticore:0.3.7

# Mythril
./smartbugs -t mythril -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/mythril:0.23.5

# Osiris
./smartbugs -t osiris -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/osiris:latest

# Oyente
./smartbugs -t oyente -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/oyente:480e725

# Pakala
./smartbugs -t pakala -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/pakala:1.1.10

# Securify
./smartbugs -t securify -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/security:usolc

# Slither
./smartbugs -t slither -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/slither:latest

# Smartcheck
./smartbugs -t smartcheck -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/smartcheck:latest

# Solhint
./smartbugs -t solhint -f $SOLIDITY_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/solhint:latest

# teEther
./smartbugs -t teether -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/teether:04adf56

# Vandal
./smartbugs -t vandal -f $RUNTIME_DATASET --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
docker rmi -f smartbugs/vandal:latest
