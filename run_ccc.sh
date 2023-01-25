#!/bin/bash

RUNID="curated"
PROCESSES=10
TIMEOUT=1800

# Access Control
./smartbugs -t ccc -f dataset/access_control/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Arithmetic
./smartbugs -t ccc -f dataset/arithmetic/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Bad Randomness
./smartbugs -t ccc -f dataset/bad_randomness/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Denial of Service
./smartbugs -t ccc -f dataset/denial_of_service/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Front Running
./smartbugs -t ccc -f dataset/front_running/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Other
./smartbugs -t ccc -f dataset/other/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Reentrancy
./smartbugs -t ccc -f dataset/reentrancy/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Short Addresses
./smartbugs -t ccc -f dataset/short_addresses/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Time Manipulation
./smartbugs -t ccc -f dataset/time_manipulation/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT

# Unchecked Low Level Calls
./smartbugs -t ccc -f dataset/unchecked_low_level_calls/*.sol --runid $RUNID --sarif --processes $PROCESSES --timeout $TIMEOUT
