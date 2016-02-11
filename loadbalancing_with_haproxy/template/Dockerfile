FROM resin/rpi-raspbian
MAINTAINER Marcel Grossmann <whatever4711@gmail.com>

VOLUME ["/haproxy"]
COPY content/consul-template /usr/local/bin/consul-template
COPY content/docker_arm /usr/local/bin/docker
ENTRYPOINT ["consul-template"]
