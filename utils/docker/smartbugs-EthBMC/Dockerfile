# Pull base image
FROM ubuntu:18.04

RUN apt-get update;
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN add-apt-repository -y ppa:sri-csl/formal-methods
RUN apt-get update; 
RUN apt-get install -y build-essential pkg-config libssl-dev git curl ethereum yices2

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup default 1.45.0
RUN rustup override set nightly

# Clone the repository
RUN git clone https://github.com/RUB-SysSec/EthBMC.git /EthBMC
WORKDIR /EthBMC
RUN git checkout 60d1b58

RUN cargo build --release

COPY scripts/run.sh .

ENTRYPOINT [ "bash", "run.sh" ]