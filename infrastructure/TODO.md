# Cluster

## CAPH

- Private network only? https://syself.com/docs/caph/reference/hetzner-cluster
- Reuse Hetzner LB https://syself.com/docs/hetzner/apalla/how-to-guides/network/configuring-a-hetzner-loadbalancer

## Access

- external-dns with source node https://kubernetes-sigs.github.io/external-dns/v0.12.2/tutorials/nodes/
- OIDC
- SOCKS https://www.inet.no/dante/ https://www.squid-cache.org/

## Default services

See 120_kubernetes/oidc/traefik/

- kyverno https://kyverno.io/
- kyverno statt Reflector
- headlamp https://github.com/kubernetes-sigs/headlamp
