#!/bin/bash
set -o errexit

docker-setup --tools=docker,buildx,docker-compose,kind,helm,kubectl,cilium install

kind create cluster --config kind.yaml

helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium \
   --namespace cilium-system \
   --create-namespace \
   --set ipam.mode=kubernetes