FROM debian:bookworm-slim

ARG VERSION=0.6.8
ARG TARGET=x86_64-unknown-linux-gnu

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Download Aderyn's prebuilt release binary and put it on PATH.
RUN curl -fsSL \
      "https://github.com/Cyfrin/aderyn/releases/download/aderyn-v${VERSION}/aderyn-${TARGET}.tar.xz" \
      -o /tmp/aderyn.tar.xz \
    && mkdir -p /tmp/aderyn \
    && tar -xJf /tmp/aderyn.tar.xz -C /tmp/aderyn \
    && find /tmp/aderyn -type f -name aderyn -exec install -m 0755 {} /usr/local/bin/aderyn \; \
    && rm -rf /tmp/aderyn /tmp/aderyn.tar.xz \
    && aderyn --version
