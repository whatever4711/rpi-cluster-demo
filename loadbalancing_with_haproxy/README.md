Loadbalancing with HAproxy
==========================

Overview
---------
This use case is about to use HAproxy as loadbalancer several webservers.

We use [Registrator from Gliderlabs](https://github.com/gliderlabs/registrator) to recognize new Docker containers that also offer a website. These new containers are registred in consul, which is globally available in the Hypriot Cluster Lab. Next, [consul-template](https://github.com/hashicorp/consul-template) recognize that a new webserver is up and tells the IP address of the new webserver to HAproxy.
Thus, HAproxy always automatically knows about all available webservers and will forward incoming requests sequentially to all of them (following round-robin strategy).

**Note:** For now, all containers are started only on a single node! We have not yet found an easy way to bring registrator, consul-template and Docker networking together. You are very welcome to join us extending this!

Let's do it step by step
------------------------

- Login via SSH to the master node of your cluster.
- Checkout this repository:

  `git clone git@github.com:hypriot/rpi-cluster-demo.git`

- Setup Haproxy, consul-template and registrator:

  `docker-compose -f loadbalancing-infrastructure.yml up -d`

- Start some webservers, distributed on cluster nodes:

  `docker-compose -f loadbalancing-applications.yml scale demo-hostname=X`

  with `X` as the number of webservers. Note that as of today the Docker daemon can only handle up to 30 containers on one Raspberry Pi by default. Thus `X` should be 30 times the number of your RPis at max.

- Open browser at IP of master node and restart page. Every page should show a new website with a new hostname because HAproxy is configured to follow the **round-robin** strategy. Thus, for every incoming HTTP request HAproxy forwards each request to a new node.


Missing feature
---------------
HAproxy is not able to forward incoming requests to containers on other nodes inside the new docker overlay network of Docker 1.9.

The reason is that gliderlabs/registrator is not yet able to manage the new Docker networking feature.

To fix this manually, you need to change each of these lines

`server node 192.168.0.138:80 maxconn 3` in `rpi-cluster-demo/haproxy/haproxy.cfg`

by replacing the IP address with the name of the container, such as
`loadbalancingwithhaproxy_demo-voting_2`.

For an automated fix, see PROPOSAL.md.


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
