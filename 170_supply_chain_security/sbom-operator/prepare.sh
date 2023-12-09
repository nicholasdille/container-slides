#!/bin/bash
set -o errexit

# tools
uniget install docker buildx docker-compose kind helm kubectl cosign helmfile

# cluster
kind create cluster --config kind.yaml

# prometheus-operator
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/latest/download/bundle.yaml | kubectl create -f -
kubectl apply -f prometheus.yaml

# sbom-system
kubectl create namespace sbom-system
kubectl -n sbom-system create secret generic sbom-operator --from-literal=accessToken=TOKEN

# helmfile
helmfile apply
kubectl apply -f ingress.yaml

# grafana admin password
kubectl -n kube-system get secret grafana -o json | jq -r '.data."admin-password"' | base64 -d