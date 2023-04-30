## DNS in Kubernetes

Kubernetes DNS model [](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

XXX IMAGE

Usually CoreDNS is used for cluster DNS

DNS record (A) for a service:<br/>`<service>.<namespace>.svc.cluster.local`

DNS record (A) for a pod:<br/>`<1-2-3-4>.<namespace>.pod.cluster.local`

Add DNS server for custom domains [](https://coredns.io/2017/05/08/custom-dns-entries-for-kubernetes/)

---

## Demo

XXX https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config

---

## Services Internals 1/

Services hide infrastructure

### Type `ClusterIP`

Service implements a load balancer

DNS record for service name is created

### Type `NodePort`

Services exposes ports on node

Default port range is 30000-32767

### Type `LoadBalancer`

Service integrated with cloud provider's load balancer

---

## Services Internals 2/2

Services hide infrastructure

### Type `ExternalName`

Maps cluster IP and DNS record to well-known name

For example, central database server

### `ClusterIP=None` (headless service)

No cluster IP and no DNS record

No load balancing

DNS records for all matched pods [](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

---

## Demo: Headless Services [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/dns/headless.demo "headless.demo")

Understand how they work