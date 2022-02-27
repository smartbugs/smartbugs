# Pull base image
FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
RUN apt update; DEBIAN_FRONTEND=noninteractive apt install -y libboost-all-dev git python3 bison \
  build-essential \
  clang \
  cmake \
  doxygen \
  flex \
  g++ \
  libffi-dev \
  libncurses5 \
  libncurses5-dev \
  libsqlite3-dev \
  make \
  mcpp \
  sqlite \
  zlib1g-dev \
  libtinfo5

RUN apt -y install wget 
RUN wget https://github.com/souffle-lang/souffle/releases/download/2.0.2/souffle_2.0.2-1_amd64.deb -O /tmp/souffle.deb
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi6_3.2.1-8_amd64.deb  -O /tmp/libffi6.deb
RUN dpkg -i /tmp/libffi6.deb
RUN dpkg -i /tmp/souffle.deb

COPY scripts/gitconfig /home/root/.gitconfig

# Clone the repository
RUN git -c "include.path=/home/root/.gitconfig" clone --recursive https://github.com/nevillegrech/MadMax.git MadMax
WORKDIR /MadMax
RUN git checkout 6e9a6e9

RUN cd gigahorse-toolchain/souffle-addon; make

# Precompile madmax.dl etc.
RUN python3 gigahorse-toolchain/gigahorse.py -C madmax.dl gigahorse-toolchain/examples/long_running.hex; rm -rf .temp results.json

COPY scripts/run.sh run.sh

ENTRYPOINT [ "bash", "run.sh" ]
