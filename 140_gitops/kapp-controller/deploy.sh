#!/bin/bash
set -o errexit

# Create cluster
if kind get clusters | grep -qv kapp; then
    kind create cluster --name kapp --config kind.yaml
    kind get kubeconfig --name kapp >${HOME}/.kube/config.kind-kapp
fi
export KUBECONFIG=${HOME}/.kube/config.kind-kapp

# If the cluster is running on a remote Docker host
if test "$(docker context ls | grep '*' | cut -d' ' -f1)" != "default"; then
    SERVER=$(
        kubectl config view --output json | \
            jq --raw-output '
                .clusters[] |
                select(.name == "kind-argocd") |
                .cluster.server
            '
    )
    IP_PORT="${SERVER#https://}"

    if ! ps -fC ssh | grep --quiet "${IP_PORT}:${IP_PORT}"; then
        ssh -fNL "${IP_PORT}:${IP_PORT}" docker-hcloud
    fi
fi

# Wait for cluster node to become ready
echo -n "Waiting for nodes to be ready..."
while kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.reason=="KubeletReady")].status}{"\n"}{end}' | grep -qE "\sFalse$"; do
    echo -n "."
    sleep 5
done
echo " done."

# Deploy kapp-controller
kubectl apply -f https://github.com/k14s/kapp-controller/releases/latest/download/release.yml
kubectl -n kapp-controller rollout status deployment kapp-controller

# RBAC
kubectl apply -f sa.yaml
