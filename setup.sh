#!/bin/bash
python3 -m venv venv
. venv/bin/activate
pip install GitPython PyYAML docker sarif-om py-solc-x
