#!/bin/bash

# tested for python >= 3.6.9
# python < 3.10 will give an error when using the ':'-feature in input patterns
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install wheel
pip install pyyaml colorama requests semantic_version docker py-cpuinfo
