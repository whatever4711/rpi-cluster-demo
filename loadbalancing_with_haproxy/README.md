HCL Demo "Loadbalancing with Haproxy"
--------------------------------
- Login via SSH to the master node of your cluster.
- Checkout this repository:

  `git clone git@github.com:hypriot/rpi-cluster-demo.git`

- Setup Haproxy, consul-template and registrator:

  `docker-compose -f loadbalancing-infrastructure.yml up -d`

- Set environment variables for Swarm:

  `export DOCKER_HOST=tcp://192.168.200.1:2378`

- Start some webservers, distributed on cluster nodes:

  `docker-compose -f loadbalancing-applications.yml scale demo-hostnameonly=X`

  with `X` as the number of webservers. Note that as of today the Docker daemon can only handle up to 30 containers on one Raspberry Pi by default. Thus `X` should be 30 times the number of your RPis at max.

- Open browser at IP of master node and restart page. Every page should show a new website with a new hostname because HAproxy is configured to follow the **round-robin** strategy for incoming HTTP requests.



//TODO HCL Demo "Loadbalancing and HA with Haproxy and Crate.io"
--------------------------------------

- Checkout "haproxy_loadbalancing_webserver_for_HA" https://github.com/hypriot/rpi-cluster-demo
- Setup Haproxy, consul-template and registrator
  `docker-compose -f hcl-infrastructure.yml up -d`
- Set ENV variable for swarm
  `export DOCKER_HOST=tcp://192.168.200.1:2378`
- Until we get crate as a distributed DB on all nodes, just run it on one node:
  `docker-compose -f hcl-applications.yml scale crate=1`
  Get the IP address of the crate container and replace it in `hcl-applications.yml` as the ENV variable of `crate`
  `docker inspect -f '{{.NetworkSettings.IPAddress}}' cluster_crate_1
  or dig @192.168.200.1 -p 8600 rpi-crate.service.dc1.consul
- Start some webservers, distributed on cluster nodes
  `docker-compose -f hcl-applications.yml scale demo=X`
  with `X` as the number of webservers
- Open browser at IP of master node and restart page. Every page should show a new website with a new hostname.
- Also if you press a button, the result will be written into the Crate.io Database. Open your on the IP addresse the crate container runs with port `:4200`, e.g. 1.2.3.4:4200
