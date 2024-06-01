#!/bin/bash

# MQTT Configuration
MQTT_HOST="127.0.0.1"
MQTT_PORT="1883"

# Define MQTT Topics
MQTT_TOPICS=(
    "new/topic"
)

# Define ThingsBoard URLs
THINGSBOARD_URLS=(
    "http://127.0.0.1:8080/api/v1/gg7ExbEDqK1Xf4dwIRu2/telemetry"
)

# Path to the JavaScript decoding script
DECODE_SCRIPT_PATH="/home/ellenfel/Desktop/iot-gateway/decode.js"

# Subscribe to MQTT topics
for ((i=0; i<${#MQTT_TOPICS[@]}; i++)); do
    mosquitto_sub -h $MQTT_HOST -p $MQTT_PORT -t ${MQTT_TOPICS[$i]} | while read -r raw_hex_message; do
        # Call the JavaScript decoding script
        decoded_message=$(node $DECODE_SCRIPT_PATH "$raw_hex_message")

        # Execute curl command with the decoded message and corresponding ThingsBoard URL
        curl -v -X POST ${THINGSBOARD_URLS[$i]} --header "Content-Type: application/json" --data "$decoded_message"
    done &
done

# Wait for all background processes to finish
wait

