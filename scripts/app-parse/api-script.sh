#!/bin/bash

# MQTT Configuration
MQTT_HOST="78.189.102.104"
MQTT_PORT="1890"
MQTT_PUB_PORT="1890"
MQTT_PUB_TOPIC="data"

# Define MQTT Topics and their corresponding ThingsBoard URLs
declare -A MQTT_TOPIC_URL_MAP=(
    ["TXUC300"]="http://127.0.0.1:8080/api/v1/LgocneeDSnVuZvBYkBFS/telemetry"
    # Add more mappings here if needed
)

# Path to the JavaScript decoding script
DECODE_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/decode.js"
PARSER_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-parse/parser.js"

# Subscribe to MQTT topics
for topic in "${!MQTT_TOPIC_URL_MAP[@]}"; do
    mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -t "$topic" | while read -r raw_hex_message; do
        # Call the JavaScript decoding script
        decoded_message=$(node $DECODE_SCRIPT_PATH "$raw_hex_message")

        # Echo the decoded message for debugging
        echo "Decoded message: $decoded_message"

        # Pass the decoded message to the parser
        parsed_output=$(node $PARSER_SCRIPT_PATH "$decoded_message")

        # Echo the parsed output for debugging
        echo "Parsed output: $parsed_output"

        # Publish the parsed output to the MQTT topic
        mosquitto_pub -h $MQTT_HOST -p $MQTT_PUB_PORT -t $MQTT_PUB_TOPIC -m "$parsed_output"
    done &
done

# Wait for all background processes to finish
wait