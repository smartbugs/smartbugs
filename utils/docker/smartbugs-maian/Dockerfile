# Docker Image with MAIAN and Solc for Augur contracts security analysis

# Pull base image
FROM ubuntu:16.04

# Install Python and build tools
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN \
  apt-get install -y build-essential software-properties-common libssl-dev wget && \
  apt-get install -y python3 python3-dev python3-pip git psmisc lsof 

# Install Solidity compiler 0.4.25 release
#RUN wget https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux && \
#  mv solc-static-linux /usr/bin/solc

# Install Solidity compiler 0.5.10 release
RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.10/solc-static-linux && \
  mv solc-static-linux /usr/bin/solc

# Install Go Ethereum (GETH) from Ethereum PPA
#RUN \
#  add-apt-repository ppa:ethereum/ethereum && \
#  apt-get update && \
#  apt-get -y install ethereum

# Install GETH version 1.8.7 (that is the version expected by MAIAN)
RUN wget https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.8.7-66432f38.tar.gz
RUN tar zxvf geth-alltools-linux-amd64-1.8.7-66432f38.tar.gz
RUN chmod +x geth-alltools-linux-amd64-1.8.7-66432f38/*
RUN cp geth-alltools-linux-amd64-1.8.7-66432f38/* /usr/local/bin

# Install MAIAN from GitHub
RUN \
  git clone https://github.com/MAIAN-tool/MAIAN.git

# Install Python dependencies

#RUN pip install --upgrade pip

COPY requirements.txt scripts/requirements.txt
RUN \
  pip3 install -r scripts/requirements.txt

# Copy test runner script to Docker image
COPY scripts/test_runner.py scripts/test_runner.py

# Set SOLC environment variable
ENV SOLC /usr/bin/solc

# Add exec rights to solc
RUN chmod +x /usr/bin/solc

# Script that extracts contract names 
ENV LC_ALL C.UTF-8  
RUN pip3 install solidity_parser
COPY scripts/printContractNames.py printContractNames.py

# Scripts that Smartbugs calls
COPY scripts/run_maian_solidity.sh run_maian_solidity.sh
COPY scripts/run_maian_bytecode.sh run_maian_bytecode.sh
RUN chmod +x printContractNames.py run_maian_solidity.sh run_maian_bytecode.sh 

# Allow insecure unlock
#RUN sed -si "s/'geth'/'geth','--allow-insecure-unlock'/g" /MAIAN/tool/blockchain.py
