#!/bin/bash
docker-compose -p loadbalancing stop
docker-compose -p loadbalancing rm -f
docker rm $(docker ps -a -q)
docker rmi $(docker images -q -f dangling=true)
docker volume rm $(docker volume ls -q)

docker network rm loadbalancing_default
docker network rm loadbalanicng_apps

