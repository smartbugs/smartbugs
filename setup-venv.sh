#!/bin/bash

python3.11 -m venv venv
source venv/bin/activate
pip install pyyaml colorama requests semantic_version docker py-cpuinfo
