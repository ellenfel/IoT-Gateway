newgrp docker

#Show both running and stopped containers (-a, --all)
docker ps -a
docker ps -f status=running

docker compose up # .yml file present
docker compose up -d # at background

docker stop tb-gateway

docker run -it -p 1884:1884 thingsboard/tb-gw-mqtt-broker:latest #gw test

mosquitto -c mosquitto.conf -v

