#!/bin/bash
set -o errexit

# MAke sure inotify limits are sufficient for monitoring components
sudo sysctl -w fs.inotify.max_user_instances=8192
sudo sysctl -w fs.inotify.max_user_watches=524288

# Create cluster
kind create cluster --config=kind.yaml

# LGTM
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# metrics-server
helm --namespace=monitoring upgrade \
    --install \
    metrics-server metrics-server/metrics-server \
        --set=args[0]=--kubelet-insecure-tls

# Grafana
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    grafana grafana-community/grafana

# Mimir
# https://grafana.com/docs/mimir/latest/set-up/helm-chart/
# https://grafana.com/docs/mimir/latest/manage/run-production-environment/planning-capacity/
#helm --namespace=monitoring upgrade \
#    --install \
#    --create-namespace \
#    mimir grafana/mimir-distributed \
#        --values=values-mimir.yaml
kubectl apply -f mimir.yaml

# Loki
# 2026-03-16: Migrated to https://github.com/grafana-community/helm-charts
# https://grafana.com/docs/loki/latest/setup/install/helm/
# https://grafana.com/docs/loki/latest/setup/install/helm/install-monolithic/
# https://grafana.com/docs/loki/latest/setup/size/
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    loki grafana-community/loki \
        --values=values-loki.yaml

# Tempo
# https://grafana.com/docs/helm-charts/tempo-distributed/next/get-started-helm-charts/
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    tempo grafana-community/tempo \
        --values=values-tempo.yaml

# CRDs
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    prometheus-operator-crds prometheus-community/prometheus-operator-crds

# https://github.com/grafana/k8s-monitoring-helm
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    k8s-monitoring grafana/k8s-monitoring --values values-k8s-monitoring.yaml

# helm: example app
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm --namespace=default upgrade \
    --install \
    my-otel-demo open-telemetry/opentelemetry-demo \
        --values=values-otel-demo.yaml