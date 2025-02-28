#!/bin/bash
set -o errexit

if test -z "${GRAFANA_CLOUD_TOKEN}"; then
    echo "ERROR: GRAFANA_CLOUD_TOKEN is not set"
    exit 1
fi

helm repo add grafana https://grafana.github.io/helm-charts
helm --namespace=default upgrade --install --create-namespace \
     grafana-k8s-monitoring grafana/k8s-monitoring --version ^2 \
    --values values.yaml \
    --atomic --timeout=300s
