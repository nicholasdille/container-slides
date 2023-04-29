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

XXX

### kubenet

No support for network policies

### Calico

XXX [](https://docs.tigera.io/calico/latest/network-policy/get-started/calico-policy/calico-network-policy)

### Cilium

XXX [](https://docs.cilium.io/en/stable/security/policy/)