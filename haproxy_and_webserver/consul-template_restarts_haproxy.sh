#!/bin/sh

HAPROXYNAME="cluster_haproxy_1"
SWARMIP=192.168.200.1

echo restarting $HAPROXYNAME on $SWARMIP

curl -X POST http://${SWARMIP}:2375/containers/${HAPROXYNAME}/restart?t=5

CONSULIP=192.168.200.1
#curl -X PUT -d "${HAPROXYNAME}" http://${CONSULIP}:8500/v1/kv/dc1/docker/restart &> /dev/null


