# Pull base image
FROM ubuntu:20.04

# Install Python and build tools
RUN \
  apt-get update && \
  apt-get install -y python3 python3-pip 

# Update pip
RUN pip3 --no-cache-dir install --upgrade setuptools pip

# Install pakala
RUN pip3 install pakala

# Script that calls Pakala
COPY scripts/runPakala.sh runPakala.sh
RUN chmod +x runPakala.sh
