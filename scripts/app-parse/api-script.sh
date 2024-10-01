#!/bin/bash

##############################################
# This script is responsible for subscribing to MQTT topics,
# decoding the received messages, parsing the decoded messages, 
# and publishing the parsed output back to an MQTT topic.
##############################################

# Define log file path
LOG_FILE="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/api-script.log"

# Redirect stdout and stderr to the log file
exec > >(tee -a "$LOG_FILE") 2>&1

# MQTT Configuration
MQTT_HOST="78.189.102.104"       # The MQTT broker host address
MQTT_PORT="1890"                 # The MQTT broker port
MQTT_PUB_PORT="1890"             # The MQTT broker port for publishing
MQTT_PUB_TOPIC="data"            # The MQTT topic to publish the parsed output

# Define MQTT Topics
MQTT_TOPICS=(
    "TXUC300"
    # Add more topics here if needed
)

# Path to the JavaScript decoding script
DECODE_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/decode.js"

# Path to the JavaScript parsing script
PARSER_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/parser.js"

# Subscribe to MQTT topics
for topic in "${MQTT_TOPICS[@]}"; do
    mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -t "$topic" | while read -r raw_hex_message; do
        # Call the JavaScript decoding script to decode the raw hex message
        decoded_message=$(node $DECODE_SCRIPT_PATH "$raw_hex_message")

        # Echo the decoded message for debugging purposes
        echo "Decoded message: $decoded_message"

        # Pass the decoded message to the parsing script to obtain the parsed output
        parsed_output=$(node $PARSER_SCRIPT_PATH "$decoded_message")

        # Echo the parsed output for debugging purposes
        echo "Parsed output: $parsed_output"

        # Publish the parsed output to the MQTT topic
        mosquitto_pub -h $MQTT_HOST -p $MQTT_PUB_PORT -t $MQTT_PUB_TOPIC -m "$parsed_output"
    done &
done

# Wait for all background processes to finish
wait
