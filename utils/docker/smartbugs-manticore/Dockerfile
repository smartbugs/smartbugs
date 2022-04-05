# Docker Image with manticore 
FROM ubuntu:18.04

LABEL name=Manticore
LABEL src="https://github.com/trailofbits/manticore"
LABEL creator="Trail of Bits"
LABEL dockerfile_maintenance=trailofbits

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8  

RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
  python3.7 \
  python3.7-dev \
  python3-pip \
  build-essential \
  git \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install solc 0.4.25 and validate it
RUN wget https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
  && chmod +x solc-static-linux \
  && mv solc-static-linux /usr/bin/solc \
  && [ "c9b268750506b88fe71371100050e9dd1e7edcf8f69da34d1cd09557ecb24580  /usr/bin/solc" = "$(sha256sum /usr/bin/solc)" ]

RUN python3.7 -m pip install --no-cache-dir --upgrade pip setuptools wheel && python3.7 -m pip install --no-cache-dir --upgrade solidity_parser

RUN git clone https://github.com/trailofbits/manticore.git && cd manticore && git checkout 0.3.7 && python3.7 -m pip install --no-cache-dir .[native] && cd .. && rm -rf manticore;

COPY scripts/printContractNames.py printContractNames.py
COPY scripts/runManticore.sh runManticore.sh
COPY scripts/analyzeBytecode.py analyzeBytecode.py
RUN chmod +x printContractNames.py runManticore.sh
ENTRYPOINT [ "bash", "runManticore.sh" ]