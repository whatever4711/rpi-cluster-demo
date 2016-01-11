Loadbalancing with HAproxy
==========================

This use case is about to use HAproxy as loadbalancer for several webservers.

We use [Registrator from Gliderlabs](https://github.com/gliderlabs/registrator) to recognize new Docker containers that also offer a website. These new containers are registered in consul, which is globally available in the Hypriot Cluster Lab. Next, [consul-template](https://github.com/hashicorp/consul-template) recognize that a new webserver is up and tells the IP address of the new webserver to HAproxy.
Thus, HAproxy always automatically knows about all available webservers and will forward incoming requests sequentially to all of them (following round-robin strategy).

![sketch](sketch_loadbalancer_demo.png)

Let's do it step by step
------------------------

- Login via SSH to the master node of your cluster.
- Checkout this repository:

```
git clone https://github.com/hypriot/rpi-cluster-demo.git
```

- Setup Haproxy, consul-template and registrator:

```
docker-compose -p infrastructure -f loadbalancing-infrastructure.yml up -d
```

- Create a new Docker overlay network

```
docker network create --driver overlay apps
```

- Start some webservers, distributed on cluster nodes:

```
docker-compose --x-networking --x-network-driver overlay -p apps -f loadbalancing-applications.yml scale demo-hostname=X
```

with `X` as the number of webservers. Note that as of today the Docker daemon can only handle up to 30 containers on one Raspberry Pi by default. Thus `X` should be 30 times the number of your RPis at max.

- Connect HAproxy to overlay network and restart it

```
docker network connect apps infrastructure_haproxy_1
docker restart infrastructure_haproxy_1
```

To test this step, you can have a look inside the HAproxy container to see if it got two network interfaces. These will be shown at the end of the following command:

```
docker inspect infrastructure_haproxy_1
```

- Open browser at IP of master node and restart page. Every page should show a new website with a new hostname because HAproxy is configured to follow the **round-robin** strategy. Thus, for every incoming HTTP request HAproxy forwards each request to a new node.


Additional commands
--------------------
- Set environment variables for Swarm:

  `export DOCKER_HOST=tcp://192.168.200.1:2378`

- Unset DOCKER_HOST variable

  `unset DOCKER_HOST`


Reset your environment
----------------------

Execute the following command in the folder in which the *.yml* files reside:
```
docker-compose -f loadbalancing-applications.yml kill && \
docker-compose -f loadbalancing-applications.yml rm -f && \
docker-compose -f loadbalancing-infrastructure.yml kill && \
docker-compose -f loadbalancing-infrastructure.yml rm -f
```
