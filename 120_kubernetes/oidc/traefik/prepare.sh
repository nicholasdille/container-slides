#!/bin/bash
set -o errexit

kind create cluster --config kind.yaml

if test -f .env; then
    source .env
fi

kubectl --namespace=external-dns create secret generic hetzner-dns-api-key \
    --from-literal=api-key=${HETZNER_DNS_API_KEY}

helmfile apply

kubectl apply -f access.yaml