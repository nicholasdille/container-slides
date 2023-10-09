## Ingress Controller

Responsible for routing requests to pods [](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

### Ingress resource

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
<!-- .element: style="float: right; width: 20em;" -->

Ingress [](https://kubernetes.io/docs/concepts/services-networking/ingress/) defines rule to match requests and how to route them

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

Match host `inmylab.de`

Match path prefix `/foo` and forward to service `foo-service`

Match path prefix `/bar` and forward to service `bar-service`

### Demo commands

Deploy ingress controller, services and test connectivity [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/30_ingress/ingress.demo)

---

## Infrastructure-as-Code

![](120_kubernetes/30_ingress/access.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 45%;" -->

Manage access automatically - as code

### Concepts

`external-dns` manages DNS records pointing to ingress controller [](https://doc.crds.dev/github.com/kubernetes-sigs/external-dns)

`cert-manager` maintains certificates for TLS termination [](https://doc.crds.dev/github.com/cert-manager/cert-manager)

Flexible ingress controllers offer important features, e.g. `traefik` [](https://traefik.io/traefik/) among others

### Outlook

`Ingress` resource: focused on HTTP(S), annotations [](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/) for advanced features

Solved by custom resources, e.g. `IngressRoute` in traefik [](https://doc.crds.dev/github.com/traefik/traefik)

---

## traefik

Supports `Ingress` resource with annotations and `IngressRoute` resource

Use with single node Docker for testing

Supports HTTP(S) and TCP

Resource definition `Middleware` to mutate requests and responses

Dashboard to inspect active configuration

### Demo

Deploy traefik as ingress controller using a host port

Deploy demo applications `foo` and `bar`

Add `IngressRoute` resources

Commands [](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/30_ingress/traefik.demo)
