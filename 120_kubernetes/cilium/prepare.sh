#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind helm kubectl cilium

kind create cluster --config kind.yaml

sysctl fs.inotify.max_user_instances=1280
sysctl fs.inotify.max_user_watches=655360

helm upgrade --install cilium cilium/cilium \
    --namespace cilium-system \
    --create-namespace \
    --set nodeinit.enabled=true \
    --set kubeProxyReplacement=partial \
    --set hostServices.enabled=false \
    --set externalIPs.enabled=true \
    --set nodePort.enabled=true \
    --set hostPort.enabled=true \
    --set ipam.mode=kubernetes \
    --set hubble.enabled=true \
    --set hubble.listenAddress=":4244" \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set hubble.ui.ingress.enabled=true \
    --set "hubble.ui.ingress.hosts[0]=hubble.seat0.inmylab.de" \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set hubble.metrics.enableOpenMetrics=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"

curl --silent --location https://github.com/kubernetes/ingress-nginx/raw/main/deploy/static/provider/kind/deploy.yaml \
| kubectl apply -f -

curl --silent --location https://github.com/cilium/cilium/raw/v1.13.2/examples/kubernetes/addons/prometheus/monitoring-example.yaml \
| kubectl apply -f -

cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus
  namespace: cilium-monitoring
spec:
  rules:
  - host: prometheus.seat0.inmylab.de
    http:
      paths:
      - backend:
          service:
            name: prometheus
            port:
              name: webui
        path: /
        pathType: Prefix
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana
  namespace: cilium-monitoring
spec:
  rules:
  - host: grafana.seat0.inmylab.de
    http:
      paths:
      - backend:
          service:
            name: grafana
            port:
              number: 3000
        path: /
        pathType: Prefix
EOF