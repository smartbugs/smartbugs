FROM --platform=linux/amd64 python:3.12-slim

WORKDIR /tmp
RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && git clone https://github.com/ConsenSys/mythril.git \
 && cd mythril \
 && pip install . \
 && cd .. \
 && apt-get purge -y git \
 && apt-get autoremove -y \
 && rm -rf mythril /var/lib/apt/lists/*
 
CMD ["/bin/bash"]
