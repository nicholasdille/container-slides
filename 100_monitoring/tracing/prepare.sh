#!/bin/bash
set -o errexit

# create cluster
kind create cluster --config kind.yaml

# ingress
curl --silent --location https://github.com/kubernetes/ingress-nginx/raw/main/deploy/static/provider/kind/deploy.yaml | kubectl apply -f -
kubectl apply -f ingress.yaml

# prometheus-operator
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/latest/download/bundle.yaml | kubectl create -f -
kubectl apply -f prometheus.yaml

# tempo
helm repo add grafana https://grafana.github.io/helm-charts
helm --namespace kube-system upgrade --install tempo grafana/tempo --values values-tempo.yaml

# grafana
helm repo update
helm --namespace kube-system upgrade --install grafana grafana/grafana --values values-grafana.yaml
kubectl --namespace kube-system get secret grafana -o json | jq -r '.data."admin-password"' | base64 -d

# install cert-manager
helm repo add jetstack https://charts.jetstack.io
helm --namespace cert-manager upgrade --install cert-manager jetstack/cert-manager \
    --create-namespace \
    --set installCRDs=true

# install opentelemetry-operator
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm --namespace kube-system upgrade --install opentelemetry-operator open-telemetry/opentelemetry-operator --values values-opentelemetry-operator.yaml