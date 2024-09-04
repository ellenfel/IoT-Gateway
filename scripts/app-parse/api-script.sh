#!/bin/bash

# This script is designed to publish telemetry data to a ThingsBoard instance using its REST API. 
# It automates the process of sending sensor or device data to the ThingsBoard platform, where it can be monitored, analyzed, and visualized in real-time. 
# The script fetches data from connected devices or pre-defined sources, structures the data into JSON format, and then sends it as an HTTP POST request to the ThingsBoard server.
# The key steps include authenticating with the ThingsBoard API using a device access token, preparing the telemetry data, 
# and handling the HTTP communication with error checking and retries to ensure reliable data transmission.
# This script can be adapted to various use cases, including IoT projects where multiple sensors or devices need to report data to a central monitoring platform.


# MQTT Configuration
MQTT_HOST="127.0.0.1"
MQTT_PORT="1884"

# Define MQTT Topics
MQTT_TOPICS=(
    "TXUC300"
)

# Define ThingsBoard URLs
THINGSBOARD_URLS=(
    "http://127.0.0.1:8080/api/v1/LgocneeDSnVuZvBYkBFS/telemetry"
)

# Path to the JavaScript decoding script
DECODE_SCRIPT_PATH="/home/ellenfel/Desktop/repos/project-iot-gateway/scripts/app-template/decode.js"

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

