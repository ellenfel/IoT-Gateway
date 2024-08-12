newgrp docker

docker run -it -p 1884:1884 thingsboard/tb-gw-mqtt-broker:latest #gw test

docker compose up
docker compose up -d # at background

mosquitto -c mosquitto.conf -v

