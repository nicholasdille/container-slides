## Node ports

![](120_kubernetes/30_ingress/node-port.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Service is exposed on all nodes

`kube-proxy` is responsible

Only port >30.000

Typical for managed clusters with hosted load balancer

External load balancer is responsble for request routing:

- Filter by host and path
- TLS termination

### Demo

Test connection to pod through service with node port [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/30_ingress/node-port.demo)
