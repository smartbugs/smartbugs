# Pull base image
FROM ubuntu:20.04

# Install Python and build tools
RUN \
  apt-get update && \
#  apt-get install -y build-essential software-properties-common libssl-dev wget && \
  apt-get install -y python3 python3-pip git curl lsb-release
# python-dev python-pip git psmisc lsof

# Install souffle
#RUN curl -s https://packagecloud.io/install/repositories/souffle-lang/souffle/script.deb.sh | bash
#RUN apt-get install souffle

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN apt install -y \
  bison \
  build-essential \
  clang \
  cmake \
  doxygen \
  flex \
  g++ \
  git \
  libffi-dev \
  libncurses5-dev \
  libsqlite3-dev \
  make \
  mcpp \
  python \
  sqlite \
  zlib1g-dev

RUN git clone https://github.com/souffle-lang/souffle /souffle

RUN cd /souffle; cmake -S . -B build -DCMAKE_INSTALL_PREFIX=/usr/local
RUN cd /souffle; cmake --build build --target install

# Clone the repository
RUN git clone https://github.com/usyd-blockchain/vandal.git /vandal

WORKDIR /vandal

RUN pip3 --no-cache-dir install --upgrade setuptools pip

RUN pip3 install -r requirements.txt

# Script that calls vandal
WORKDIR /
COPY scripts/runVandal.sh runVandal.sh
RUN chmod +x runVandal.sh
