#!/bin/bash
python3.8 -m venv venv
. venv/bin/activate
pip install --upgrade pip
pip install GitPython PyYAML docker sarif-om colorama semantic-version
