# Docker Image with MAIAN (Smartbugs fork)

# Pull base image
FROM ubuntu:20.04

# Update packages, install build essentials, wget and Python
RUN \
  apt update; \
  DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    tzdata build-essential software-properties-common libssl-dev wget git \
    z3 psmisc lsof wget python3-pip python3-dev; \
  pip install --upgrade pip

# Install GETH version 1.10.14 
RUN \
  wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.14-11a3a350.tar.gz && \
  tar zxvf geth-linux-amd64-1.10.14-11a3a350.tar.gz && \
  cp geth-linux-amd64-1.10.14-11a3a350/geth /usr/local/bin && \
  chmod +x /usr/local/bin/geth

# Precompute ethash data
RUN \
  mkdir ~/.ethash; \
  for block in 0 30000; do \
    geth makedag $block ~/.ethash; \
  done

# Script that extracts contract names 
ENV LC_ALL C.UTF-8  
RUN pip3 install solidity_parser
COPY scripts/printContractNames.py printContractNames.py

# Scripts that Smartbugs calls
COPY scripts/runMAIANall.sh runMAIANall.sh
COPY scripts/run_maian_solidity.sh run_maian_solidity.sh
COPY scripts/run_maian_bytecode.sh run_maian_bytecode.sh
RUN chmod +x printContractNames.py run_maian_solidity.sh run_maian_bytecode.sh runMAIANall.sh

# Install MAIAN from GitHub, precompile and test it
ARG MAIAN_COMMIT=master
RUN \
  git clone https://github.com/smartbugs/MAIAN; \
  cd /MAIAN; \
  git checkout $MAIAN_COMMIT; \
  pip3 install -r requirements-3.8.txt; \
  cd tool; \
  for c in 0 1 2; do \
    python3 maian.py -bs example_contracts/example_suicidal.bytecode_source -c $c; \
  done; \
  rm -rf out/*

# Install Solidity compiler
ARG SOLC_VERSION=0.5.10
RUN \
  wget https://github.com/ethereum/solidity/releases/download/v$SOLC_VERSION/solc-static-linux && \
  mv solc-static-linux /usr/bin/solc && \
  chmod +x /usr/bin/solc

ENV SOLC /usr/bin/solc

