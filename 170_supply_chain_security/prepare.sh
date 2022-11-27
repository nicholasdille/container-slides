#!/bin/bash
set -o errexit

# cluster
kind create cluster --config kind.yaml

# ingress
curl --silent --location https://github.com/kubernetes/ingress-nginx/raw/main/deploy/static/provider/kind/deploy.yaml | kubectl apply -f -
kubectl apply -f ingress.yaml

# prometheus-operator
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.60.1/bundle.yaml | kubectl create -f -
kubectl apply -f prometheus.yaml

# grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm --namespace kube-system upgrade --install grafana grafana/grafana --values values-grafana.yaml
kubectl -n kube-system get secret grafana -o json | jq -r '.data."admin-password"' | base64 -d