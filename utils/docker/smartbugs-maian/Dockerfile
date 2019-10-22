# Docker Image with MAIAN and Solc for Augur contracts security analysis

# Pull base image
FROM ubuntu:16.04

# Install Python and build tools
RUN \
  apt-get update && \
  apt-get install -y build-essential software-properties-common libssl-dev wget && \
  apt-get install -y python python-dev python-pip git psmisc lsof

# Install Solidity compiler 0.4.25 release
#RUN wget https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux && \
#  mv solc-static-linux /usr/bin/solc

# Install Solidity compiler 0.5.10 release
RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.10/solc-static-linux && \
  mv solc-static-linux /usr/bin/solc

# Install Go Ethereum (GETH) from Ethereum PPA
RUN \
  add-apt-repository ppa:ethereum/ethereum && \
  apt-get update && \
  apt-get -y install ethereum

# Install MAIAN from GitHub
RUN \
  git clone https://github.com/MAIAN-tool/MAIAN.git

# Install Python dependencies

RUN pip install --upgrade pip

COPY requirements.txt scripts/requirements.txt
RUN \
  pip install -r scripts/requirements.txt

# Copy test runner script to Docker image
COPY scripts/test_runner.py scripts/test_runner.py

# Set SOLC environment variable
ENV SOLC /usr/bin/solc

# Add exec rights to solc
RUN chmod +x /usr/bin/solc

# Extract contract names automatically
RUN apt-get -y install python3-pip

ENV LC_ALL C.UTF-8  

RUN pip3 --no-cache-dir install --upgrade setuptools pip

RUN pip3 install solidity_parser

COPY scripts/printContractNames.py printContractNames.py
COPY scripts/runMAIANall.sh runMAIANall.sh
RUN chmod +x printContractNames.py runMAIANall.sh

# Allow insecure unlock
RUN sed -si "s/'geth'/'geth','--allow-insecure-unlock'/g" /MAIAN/tool/blockchain.py
