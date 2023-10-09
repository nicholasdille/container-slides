## Host ports

![](120_kubernetes/30_ingress/host-port.drawio.svg) <!-- .element: style="float: right; width: 30%;" -->

Host port is directly forwarded to pod

Only available on the node where the pod is running

Well-known ports can only be used once per node

Typical for self-hosted clusters without load balancer

Pod is responsible for request routing:

- Filtering by host and port
- TLS termination

### Demo

Test connection to pod with host port [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/30_ingress/host-port.demo)
