# GPTScan as a SmartBugs tool.
#
# Build (from this directory; the tag must match "image:" in ../config.yaml):
#   docker build -t smartbugs/gptscan:29a1747 .
#
# The image is built from a fork of https://github.com/GPTScan/GPTScan
# (upstream commit 29a1747) that adapts the tool for SmartBugs: provider and
# model selection at run time, a dry-run mode, timeout handling, a removed
# debugger breakpoint. The fork commit is pinned below.
#
# The image bundles GPTScan with its runtime (Python 3.10, Java 17, a fallback
# solc). No API key is baked in; DEEPSEEK_API_KEY / OPENAI_API_KEY and the
# GPTSCAN_* variables are forwarded by SmartBugs at run time (see "env:" in
# ../config.yaml). SmartBugs overrides the entrypoint with scripts/do_solidity.sh.
FROM --platform=linux/amd64 python:3.10-bookworm

ARG REPO=https://github.com/Alex-Hofer/GPTScan.git
ARG COMMIT=869ce282be743859e719f8f1aa49fa38dbe995cc

# Java 17 (GPTScan requirement); git stays installed because one dependency
# (falcon-analyzer) is installed from git.
RUN apt-get update \
 && apt-get install -y --no-install-recommends openjdk-17-jre-headless git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN git init -q /opt/gptscan \
 && git -C /opt/gptscan remote add origin ${REPO} \
 && git -C /opt/gptscan fetch -q --depth 1 origin ${COMMIT} \
 && git -C /opt/gptscan checkout -q FETCH_HEAD \
 && rm -rf /opt/gptscan/.git

WORKDIR /opt/gptscan

# Curated dependency set; requirements-docker.txt in the fork explains why
# not requirements.txt.
RUN pip install --no-cache-dir -r requirements-docker.txt

# Pre-cache the tiktoken encoding so a scan never depends on a network fetch.
RUN python -c "import tiktoken; tiktoken.get_encoding('cl100k_base')"

# A default solc as a standalone fallback. Under SmartBugs the matching solc is
# provided via the mount (config.yaml: solc: yes) and takes precedence on PATH.
RUN pip install --no-cache-dir solc-select \
 && solc-select install 0.8.19 \
 && solc-select use 0.8.19

# GPTScan reads rules/, tasks/, jars/ relative to the working directory.
WORKDIR /opt/gptscan/src
