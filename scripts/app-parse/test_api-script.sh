#!/bin/bash

# Path to the JavaScript decoding script
DECODE_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/decode.js"

# Test input data
TEST_INPUTS=(
    "7ef4 8100 0b5e 4ac4 661d 0300 5500 0000 0309 0000 0b09 0000 1309 0000 1b09 0000 2309 0000 2b09 0000 3309 0000 3b09 0000 4309 0000 4b09 0000 5309 0000 5b09 0000 6309 0000 6b09 0000 7309 0000 7b09 0000 8309 0000 8b09 1801 9309 1801 9b09 1801 a309 0000 ab09 0000 b309 0000 bb09 0000 c309 0000 cb09 0000 d309 0000 db09 0000 7e"  # "Mocha Language Test"
)

# Run tests
for ((i=0; i<${#TEST_INPUTS[@]}; i++)); do
    test_input=${TEST_INPUTS[$i]}
    decoded_output=$(node $DECODE_SCRIPT_PATH "$test_input")

    echo $decoded_output
done

