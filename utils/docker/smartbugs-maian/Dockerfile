# Docker Image with MAIAN (Smartbugs fork)

# Pull base image
FROM ubuntu:20.04

# Update packages, install build essentials, wget and Python
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends tzdata \
  build-essential software-properties-common libssl-dev wget git z3 psmisc lsof \
  wget python3-pip python3-dev

# Upgrade pip
RUN pip install --upgrade pip

# Install GETH version 1.10.14 
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.14-11a3a350.tar.gz
RUN tar zxvf geth-linux-amd64-1.10.14-11a3a350.tar.gz
RUN cp geth-linux-amd64-1.10.14-11a3a350/geth /usr/local/bin
RUN chmod +x /usr/local/bin/geth

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

# Install Solidity compiler 0.4.25 release
#RUN wget https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux && \
#  mv solc-static-linux /usr/bin/solc

# Install Solidity compiler 0.5.10 release
RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.10/solc-static-linux && \
  mv solc-static-linux /usr/bin/solc

# Set SOLC environment variable
ENV SOLC /usr/bin/solc

# Add exec rights to solc
RUN chmod +x /usr/bin/solc

# Install MAIAN from GitHub
RUN git clone https://github.com/smartbugs/MAIAN

# Checkout specific version of MAIAN's repository and install requirements
#RUN cd /MAIAN; git checkout 8bf16ac; pip3 install -r requirements-3.8.txt
RUN cd /MAIAN; git checkout 088a213; pip3 install -r requirements-3.8.txt

# Precompile program, test Maian installation
RUN \
  cd /MAIAN/tool; \
  for c in 0 1 2; do \
    python3 maian.py -bs example_contracts/example_suicidal.bytecode_source -c $c; \
  done; \
  rm -rf out/*
