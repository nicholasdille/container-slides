## Cilium

![](images/cilium.svg) <!-- .element: style="float: right; width: 25%;" -->

CNI plugin based on eBPF [](https://ebpf.io/)

CNCF incubation project [](https://www.cncf.io/projects/cilium/)

### Additional Features

Network Policy

kube-proxy replacement

Hubble for visibility

Metrics for observability

Multi-cluster connectivity

Service Mesh

CNI chaining for policy features on top of other CNI plugins, e.g. AWS VPC CNI

---

## Cilium Internals

![](120_kubernetes/cilium/agents.drawio.svg) <!-- .element: style="float: right; width: 45%;" -->

Cilium agent manages the network

All pods are an endpoint

Endpoints are assigned an identity

Identities have labels to describe them