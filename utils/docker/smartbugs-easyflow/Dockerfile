# Pull base image
FROM ubuntu:16.04

RUN apt-get update; apt-get install -y build-essential git wget python

RUN wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.10.3.linux-amd64.tar.gz
RUN rm go1.10.3.linux-amd64.tar.gz

# Clone the repository
RUN git clone https://github.com/Jianbo-Gao/EasyFlow /EasyFlow
WORKDIR /EasyFlow

RUN git checkout c7a34b6
RUN PATH=$PATH:/usr/local/go/bin make evm

COPY scripts/run.sh run.sh

ENTRYPOINT [ "bash", "run.sh" ]