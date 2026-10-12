# LLMSmartAudit as a SmartBugs tool.
#
# Build (from this directory; the tag must match "image:" in ../config.yaml):
#   docker build -t smartbugs/llmsmartaudit:c507fe4 .
#
# The image is built from a fork of https://github.com/LLMAudit/LLMSmartAuditTool
# (upstream commit c507fe4) that adapts the tool for SmartBugs: provider and
# model selection at run time,
# a report collector that keeps the result of every detector phase, headless
# operation. The commit is pinned below. The fork's branch does not carry the
# upstream evaluation data (3.7 GB), so the fetch stays small.
#
# No API key is baked in. DEEPSEEK_API_KEY / OPENAI_API_KEY and LLM_MODEL are
# forwarded by SmartBugs at run time (see "env:" in ../config.yaml); the
# entrypoint refuses to start without LLM_MODEL.
FROM --platform=linux/amd64 python:3.10-slim

ARG REPO=https://github.com/Alex-Hofer/LLMSmartAuditTool.git
ARG COMMIT=a0d09a5393fddfc53267cbc6e284aa348a2d0ede

WORKDIR /app
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates \
 && git init -q /app \
 && git -C /app remote add origin ${REPO} \
 && git -C /app fetch -q --depth 1 origin ${COMMIT} \
 && git -C /app checkout -q FETCH_HEAD \
 && rm -rf /app/.git \
 && apt-get purge -y git \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

# requirements.txt pins httpx<0.28 (openai 1.3.3 compatibility).
RUN pip install --no-cache-dir -r requirements.txt

# The tool lists WareHouse/ at startup; make sure it exists.
RUN mkdir -p /app/WareHouse

# Provider default; LLM_MODEL is deliberately not set here (see above).
ENV LLM_PROVIDER=deepseek
# The tool prints emoji in its summary; avoid UnicodeEncodeError.
ENV PYTHONIOENCODING=utf-8

# SmartBugs overrides the entrypoint via config.yaml; this is only a default.
ENTRYPOINT ["/bin/sh"]
