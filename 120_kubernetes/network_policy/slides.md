## Network Policy

Firewall for intra-cluster communication [](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

Must be implemented by CNI plugin

### Resource `NetworkPolicy` (namespaced)

Network policies are enforced per namespace

Allow all traffic without policies

Deny by default when a policy exists

Policies can only allow traffic

Policies are applied using label selector

Ingress and egress are handled separately

Supports layer 3 and layer 4

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

kubenet, [flannel](https://github.com/flannel-io/flannel), [kindnet](https://github.com/aojea/kindnet)

### Calico

Pluggable data planes [](https://www.tigera.io/project-calico/) and extended network policies [](https://docs.tigera.io/calico/latest/network-policy/get-started/calico-policy/calico-network-policy)

Calico the hard way [](https://docs.tigera.io/calico/latest/getting-started/kubernetes/hardway/overview)

### Canel

Flannel for networking and Calico for policy [](https://docs.tigera.io/calico/latest/getting-started/kubernetes/flannel/install-for-flannel#installing-calico-for-policy-and-flannel-aka-canal-for-networking)

### Cilium

Based on eBPF [](https://ebpf.io/) with extended network policies [](https://docs.cilium.io/en/stable/security/policy/) and observability [](https://docs.cilium.io/en/stable/gettingstarted/hubble_intro/)

---

## Demo

Filter connections between pods

![](120_kubernetes/network_policy/network_policy.drawio.svg) <!-- .element: style="width: 50%; margin-top: 0.5em;" -->

### Egress

Control HTTP from `test1` to `test2`

Requires DNS to work

Enable access to Kubernetes API