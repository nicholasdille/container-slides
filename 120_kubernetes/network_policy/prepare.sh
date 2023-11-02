#!/bin/bash
set -o errexit

uniget install docker buildx docker-compose kind helm kubectl cilium

kind create cluster --config kind.yaml

helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium \
   --namespace cilium-system \
   --create-namespace \
   --set ipam.mode=kubernetes