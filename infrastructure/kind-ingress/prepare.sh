#!/bin/bash
set -o errexit

ssh playground kind create cluster --config kind.yaml
scp playground:~/.kube/config ./kubeconfig
export KUBECONFIG=$(pwd)/kubeconfig
PORT="$(
    kubectl config view --output=json \
    | jq --raw-output '.clusters[] | select(.name == "kind-kind") | .cluster.server' \
    | cut -d: -f3
)"
ssh -fNL ${PORT}:localhost:${PORT} playground

# https://github.com/kubernetes-sigs/cloud-provider-kind
docker build . --tag cloud-provider-kind
docker run \
    --detach \
    --rm \
    --name=cloud-provider-kind \
    --network=host \
    --volume=/var/run/docker.sock:/var/run/docker.sock \
    cloud-provider-kind
