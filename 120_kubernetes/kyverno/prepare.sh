#!/bin/bash
set -o errexit

docker-setup --tools=docker,buildx,docker-compose,kind,helm,kubectl,gvisor,cosign,kyverno install

kind create cluster

helm repo add kyverno https://kyverno.github.io/kyverno/
helm --namespace kyverno upgrade --install --create-namespace kyverno kyverno/kyverno --set replicaCount=3