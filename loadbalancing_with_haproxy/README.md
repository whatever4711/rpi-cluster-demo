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
docker-compose -p loadbalancing up -d
```

- Start some webservers, distributed on cluster nodes:

```
docker-compose -p loadbalancing scale demo-hostname=X
```

with `X` as the number of webservers. Note that as of today the Docker daemon can only handle up to 30 containers on one Raspberry Pi by default. Thus `X` should be 30 times the number of your RPis at max.


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
docker-compose -p loadbalancing kill && \
docker-compose -p loadbalancing rm -f 
```
