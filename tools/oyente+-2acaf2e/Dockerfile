FROM python:3.11-slim
LABEL maintainer="SmartBugs Project <https://github.com/smartbugs/oyente_plus"

ARG SOLC_VERSION=0.8.30
ARG COMMIT=2acaf2e
ENV SOLC_VERSION=${SOLC_VERSION}

# Install dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
        ca-certificates \
        git \
    && pip install --no-cache-dir --upgrade pip wheel \
    && pip install --no-cache-dir \
        cbor2 \
        crytic-compile==0.3.8 \
        requests \
        six \
        solc-select \
        typing_extensions \
        z3-solver==4.14.1.0 \
    && pip install --no-cache-dir git+https://github.com/gsalzer/ethutils.git@main#egg=ethutils \
    && git clone https://github.com/smartbugs/oyente_plus.git \
    && cd oyente_plus \
    && git reset --hard ${COMMIT} \
    && mv oyente /oyente \
    && cd .. \
    && rm -rf oyente_plus \
    && apt remove -y git \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install chosen solidity compiler version
RUN solc-select install ${SOLC_VERSION}

# Copy and initialize Oyente
RUN python3 -O -m compileall -f /oyente

ENTRYPOINT ["python3", "/oyente/oyente.py"]
