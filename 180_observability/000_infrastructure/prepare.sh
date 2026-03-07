#!/bin/bash
set -o errexit

kind create cluster --config=kind.yaml

# LGTM
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add minio https://charts.min.io/
helm repo update

# Grafana
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    grafana grafana-community/grafana \
        --values=values-grafana.yaml

# MinIO
helm --namespace=minio upgrade \
    --install \
    --create-namespace \
    minio minio/minio \
        --values=values-minio.yaml

# Mimir
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    mimir grafana/mimir-distributed \
        --values=values-mimir-small.yaml

# Loki
# 2026-03-16: Migrated to https://github.com/grafana-community/helm-charts
# https://grafana.com/docs/loki/latest/setup/install/helm/
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    loki grafana/loki \
        --values=values-loki-simple-scalable.yaml

# Tempo
# https://grafana.com/docs/helm-charts/tempo-distributed/next/get-started-helm-charts/
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    tempo grafana-community/tempo-distributed \
        --values=values-tempo.yaml

# https://github.com/grafana/k8s-monitoring-helm
# https://grafana.com/docs/grafana-cloud/monitor-infrastructure/kubernetes-monitoring/configuration/helm-chart-config/helm-chart/


# helm: example app
