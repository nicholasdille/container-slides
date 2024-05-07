#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind helm kubectl cosign kyverno

kind create cluster

helm repo add kyverno https://kyverno.github.io/kyverno/
helm --namespace kyverno upgrade --install --create-namespace kyverno kyverno/kyverno