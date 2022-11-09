## User access

How do users access the containerized services?

### Remember container networking

Containers are not accessible by default

### Same challenges for Kubernetes

XXX

---

## Ingress Controller

Responsible for routing requests to containers [](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

Maintains rules for matching hosts and paths

![](120_kubernetes/30_ingress/host_port.drawio.svg) <!-- .element: style="float: right; width: 30%;" -->

### Option 1: Host ports

Host port is directly forwarded to container

One port per host per port

Typical for self-hosted clusters without load balancer

### Option 2: Node ports

![](120_kubernetes/30_ingress/node_port.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

`kube-proxy` opens port >30.000 on all nodes...

...and forwards requests to a service

Typical for hosted clusters with hosted load balancer

---

## Ingress resource

Ingress [](https://kubernetes.io/docs/concepts/services-networking/ingress/) defines rule to match requests and how to route them

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: inmylab.de
    http:
      paths:
      - pathType: Prefix
        path: "/foo"
        backend:
          service:
            name: foo-service
            port:
              number: 5678
```
<!-- .element: style="float: right; width: 22em;" -->

### Request matching

Wildcard host names are allowed

Match paths using `Exact` or `Prefix`

### Target service

Can be backed by multiple pods

Service takes care of load balancing

---

## Demo: Ingress (controller)

Using nginx-based ingress controller [](https://github.com/kubernetes/ingress-nginx)

![](120_kubernetes/30_ingress/demo.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 45%;" -->

### Backend

Two pods `foo` and `bar` and...

...accompanying services

### Request matching

Match host inmylab.de

Match path prefix `/foo` and forward to service `foo-service`

Match path prefix `/bar` and forward to service `bar-service`

---

## Infrastructure-as-Code

Manage user access automatically

Define as code

![](120_kubernetes/30_ingress/access.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 45%;" -->

### Concepts

DNS records route requests to hosts running the ingress controller (managed by `external-dns`)

Connections are secured using TLS (certificates managed by `cert-manager`)

Use more flexible ingress controller, e.g. traefik [](https://traefik.io/traefik/) and many others

Shortcomings of `Ingress` resource: focused on HTTP(S), annotations [](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/) for advanced features

Solved by custom resources in some ingress controllers, e.g. `IngressRoute` in traefik

Outlook: Gateway API [](https://gateway-api.sigs.k8s.io/)