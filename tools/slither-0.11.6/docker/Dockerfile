FROM --platform=linux/amd64 python:3.13-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git \
      build-essential \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
RUN git clone https://github.com/crytic/slither.git \
 && cd slither \
 && git checkout 0.11.6
RUN pip install --no-cache-dir ./slither

CMD ["/bin/bash"]
