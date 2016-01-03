Proposal to fix gliderlabs/registrator issue
=============================================

Problem:
-----------
Gliderlabs/registrator is not yet able to manage the new Docker networking feature.

Proposed solution
------------------
- create event listener in consul
- write script to be executed from the listener:
  - read services

    `curl -sLX GET http://192.168.200.1:8500/v1/catalog/services | tac | tac | jq '.'`

  - from the output of next command, extract value of `ServiceID` and write to K/V store

    `curl -sLX GET http://192.168.200.1:8500/v1/catalog/service/rpi-haproxy-80 | tac | tac | jq '.'`

- change HAproxy consul template (haproxy.ctmpl) to use the K/V values instead of `{{.Address}}` in line
` server node {{.Address}}:{{.Port}} maxconn 3 {{end}}{{end}}{{end}}
`
