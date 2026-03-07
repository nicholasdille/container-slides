#!/bin/bash
set -o errexit

kind create cluster \
    --config kind.yaml \
    --wait 5m

# Deploy Cilium with...
# - kube-proxy replacement
# - Layer 2 Announcement (LoadBalancer)
helm repo add cilium https://helm.cilium.io/
helm upgrade --namespace kube-system --install \
    cilium cilium/cilium \
        --set kubeProxyReplacement=true \
        --set l2announcements.enabled=true \
        --set k8sServiceHost=kind-control-plane \
        --set k8sServicePort=6443 \
        --set l7Proxy=false \
        --set ipam.mode=kubernetes \
        --set hubble.enabled=false

# Create IP pool
cat <<EOF | kubectl apply -f -
apiVersion: cilium.io/v2
kind: CiliumLoadBalancerIPPool
metadata:
  name: test
spec:
  blocks:
  - start: 100.64.1.250
    stop: 100.64.1.255
EOF

# Deploy traefik
helm repo add traefik https://traefik.github.io/charts
helm upgrade --namespace kube-system --install \
    traefik traefik/traefik \
        --set deployment.replicas=2

# Deploy test service
helm repo add stefanprodan https://stefanprodan.github.io/podinfo
helm upgrade --install \
    podinfo stefanprodan/podinfo \
        --set replicaCount=2 \
        --set ingress.enabled=true

# Test ingress
docker exec -it kind-control-plane \
    curl --verbose --resolve podinfo.local:80:100.64.1.250 http://podinfo.local/