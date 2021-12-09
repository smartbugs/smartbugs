# Docker Image with manticore 

# Pull base image
FROM trailofbits/manticore:0.3.6

# Extract contract names automatically
RUN apt-get -y install python3-pip

ENV LC_ALL C.UTF-8  

RUN pip3 --no-cache-dir install --upgrade setuptools pip

RUN pip3 install solidity_parser

COPY scripts/printContractNames.py printContractNames.py
COPY scripts/runManticore.sh runManticore.sh
COPY scripts/analyzeBytecode.py analyzeBytecode.py
RUN chmod +x printContractNames.py runManticore.sh
ENTRYPOINT [ "bash", "runManticore.sh" ]