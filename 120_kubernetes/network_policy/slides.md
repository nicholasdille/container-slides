## Network Policy

Firewall for intra-cluster communication [](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

Must be implemented by CNI plugin

### Resource `NetworkPolicy`

Allow all trafic without policies

Deny by default when a policy exists

Policies only allow traffic

Supports layer 3 and 4

There is an editor [](https://editor.networkpolicy.io)

---

## Limitations

No traffic routing

No TLS

No node specific policies

No targeting of services

No cluster-wide default policies

No audit logging

---

## CNI plugins

### No support for network policy

kubenet, [flannel](https://github.com/flannel-io/flannel)

### Calico

Pluggable data planes [](https://www.tigera.io/project-calico/) and extended network policies [](https://docs.tigera.io/calico/latest/network-policy/get-started/calico-policy/calico-network-policy)

Calico the hard way [](https://docs.tigera.io/calico/latest/getting-started/kubernetes/hardway/overview)

### Canel

Flannel for networking and Calico for policy [](https://docs.tigera.io/calico/latest/getting-started/kubernetes/flannel/install-for-flannel#installing-calico-for-policy-and-flannel-aka-canal-for-networking)

### Cilium

Based on eBPF [](https://ebpf.io/) with extended network policies [](https://docs.cilium.io/en/stable/security/policy/) and observability [](https://docs.cilium.io/en/stable/gettingstarted/hubble_intro/)

---

## Demo

![](120_kubernetes/network_policy/network_policy.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Filter connections between them

XXX