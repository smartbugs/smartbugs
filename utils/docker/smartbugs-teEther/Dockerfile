# Pull base image
FROM python:3.8-slim

RUN apt-get update; apt-get install -y git build-essential

# Clone the repository
RUN git clone https://github.com/nescio007/teether.git
WORKDIR /teether
RUN git checkout 04adf56

RUN mv teether/cfg/bb.py teether/cfg/bb.orig.py; \
    sed '/Failed to compute jump target for BB\|Jump to invalid address/s/^/#/' \
    teether/cfg/bb.orig.py > teether/cfg/bb.py

RUN python3 setup.py install

ENTRYPOINT [ "python3", "bin/gen_exploit.py" ]