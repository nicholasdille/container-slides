#!/bin/bash
set -o errexit

kind create cluster \
    --config kind.yaml \
    --wait 5m

# Deploy Cilium with...
# - kube-proxy replacement
# - Layer 2 Announcement (LoadBalancer)
helm upgrade --namespace kube-system --install \
    cilium cilium/cilium \
        --set kubeProxyReplacement=strict \
        --set l2announcements.enabled=true \
        --set k8sServiceHost=kind-control-plane \
        --set k8sServicePort=6443 \
        --set l7Proxy=false \
        --set ipam.mode=kubernetes \
        --set hubble.enabled=false

# Create IP pool
cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2alpha1
kind: CiliumLoadBalancerIPPool
metadata:
  name: test
spec:
  blocks:
  - start: 10.222.100.10
    stop: 10.222.100.30
EOF

# Deploy traefik
helm upgrade --namespace kube-system --install \
    traefik traefik/traefik \
        --set deployment.replicas=2

# Deploy test service
helm upgrade --install \
    podinfo podinfo/podinfo \
        --set replicaCount=2 \
        --set ingress.enabled=true

# Test ingress
docker exec -it kind-control-plane \
    curl --verbose --resolve podinfo.local:80:10.222.100.11 http://podinfo.local/