## User access

XXX

### Remember container networking

XXX image about container and host ports

### Same challenges for Kubernetes

XXX

---

## Ingress Controller

Responsible for routing requests to containers [](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

XXX image about ingress?

XXX host port in pod (host port forward to port, any port)

![](120_kubernetes/30_ingress/host_port.drawio.svg) <!-- .element: style="width: 30%;" -->

XXX node port in service provided by kube-proxy (port >30.000)

![](120_kubernetes/30_ingress/node_port.drawio.svg) <!-- .element: style="width: 45%;" -->

---

## Ingress resource

XXX [](https://kubernetes.io/docs/concepts/services-networking/ingress/)

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

---

## Demo: Ingress (controller)

XXX demo used nginx-based ingress controller [](https://github.com/kubernetes/ingress-nginx)

![](120_kubernetes/30_ingress/demo.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 45%;" -->

---

## XXX

![](120_kubernetes/30_ingress/access.drawio.svg) <!-- .element: style="float: right; padding-left: 1em; width: 45%;" -->

external-dns for managing DNS records

cert-manager for managing certificates

XXX more flexible ingress controllers, e.g. traefik [](https://traefik.io/traefik/)

XXX shortcomings of ingress resource: focus on HTTP, annotations [](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)

XXX custom resources, e.g. IngressRoute in traefik

XXX future: Gateway API [](https://gateway-api.sigs.k8s.io/)