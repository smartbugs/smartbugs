# Pull base image
FROM ubuntu:20.04

# Update packages, install build essentials, wget and Python
RUN \
  apt update; \
  DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    tzdata build-essential software-properties-common libssl-dev wget git \
    z3 psmisc lsof wget python3 python3-pip python3-dev; \
  pip install --upgrade pip

# Install GETH version 1.10.14 
RUN \
  wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.14-11a3a350.tar.gz && \
  tar zxvf geth-linux-amd64-1.10.14-11a3a350.tar.gz && \
  cp geth-linux-amd64-1.10.14-11a3a350/geth /usr/local/bin && \
  chmod +x /usr/local/bin/geth && \
  rm geth-linux-amd64-1.10.14-11a3a350.tar.gz

# Update pip
RUN pip3 --no-cache-dir install --upgrade setuptools pip

# Install pakala
RUN pip3 install pakala

# Script that calls Pakala
COPY scripts/runPakala.sh runPakala.sh
RUN chmod +x runPakala.sh
