## Node ports

![](120_kubernetes/30_ingress/node_port.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

`kube-proxy` opens port >30.000 on all nodes...

...and forwards requests to a service

Typical for hosted clusters with hosted load balancer

XXX Host, path, TLS?
