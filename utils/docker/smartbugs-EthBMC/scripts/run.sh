#!/bin/sh

FILENAME=$1
CODE=$(cat ${FILENAME})

echo "
state:
    0xaad62f08b3b9f0ecc7251befbeff80c9bb488fe9:
        balance: 0x0
        nonce: 0x1000000
        code: ${CODE}

victim: 0xaad62f08b3b9f0ecc7251befbeff80c9bb488fe9
" > input.yml

cat input.yml

RUST_BACKTRACE=1 ./target/release/ethbmc input.yml
