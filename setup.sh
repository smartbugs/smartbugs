#!/bin/bash
python3.8 -m venv venv
. venv/bin/activate
pip install GitPython PyYAML docker sarif-om py-solc-x
