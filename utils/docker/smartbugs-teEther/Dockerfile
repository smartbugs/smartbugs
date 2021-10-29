# Pull base image
FROM python:3.8-slim

RUN apt-get update; apt-get install -y git build-essential

# Clone the repository
RUN git clone https://github.com/nescio007/teether.git
WORKDIR /teether
RUN git checkout 04adf56

RUN python3 setup.py install

ENTRYPOINT [ "python3", "bin/gen_exploit.py" ]