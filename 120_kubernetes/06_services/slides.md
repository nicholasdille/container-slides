## Services

Pods receive a dedicated IP address but no DNS name

![Services distribute requests among pods](120_kubernetes/06_services/dns.drawio.svg) <!-- .element: style="float: right; width: 20%;" -->

### Services provide DNS

DNS records for pods

### Services provide load balancing

![Services distribute requests among pods](120_kubernetes/06_services/load_balancing.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

Services are a reverse proxy with a dedicated IP address

Requests are distributed among pods

Target pods are selected using labels

### Demo

XXX [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/06_services/service.demo)
