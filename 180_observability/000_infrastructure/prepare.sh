#!/bin/bash
set -o errexit

kind create cluster --config=kind.yaml
mkdir -p /data/loki
chown 10001:10001 /data/loki

# LGTM
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add minio https://charts.min.io/
helm repo update

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
#    mimir grafana/mimir-distributed
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

# https://github.com/grafana/k8s-monitoring-helm
# https://grafana.com/docs/grafana-cloud/monitor-infrastructure/kubernetes-monitoring/configuration/helm-chart-config/helm-chart/


# helm: example app
