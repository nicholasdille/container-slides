#!/bin/bash
set -o errexit

if test -z "${GITHUB_TOKEN}"; then
    echo "ERROR: Must export GITHUB_TOKEN!"
    exit 1
fi

# Create cluster
if ! kind get clusters | grep --quiet flux2; then
    kind create cluster --name flux2 --config kind.yaml
    kind get kubeconfig --name flux2 >${HOME}/.kube/config.kind-flux2
fi
export KUBECONFIG=${HOME}/.kube/config.kind-flux2

# If the cluster is running on a remote Docker host
if test "$(docker context ls | grep '*' | cut -d' ' -f1)" != "default"; then
    SERVER=$(
        kubectl config view --output json | \
            jq --raw-output '
                .clusters[] |
                select(.name == "kind-flux2") |
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

# Install CLI
if ! type flux >/dev/null 2>&1; then
    curl -sL https://github.com/fluxcd/flux2/releases/download/v0.14.2/flux_0.14.2_linux_amd64.tar.gz | tar -xzC /usr/local/bin/
fi
eval "$(flux completion bash)"

# Deploy flux2
flux bootstrap github \
    --owner=nicholasdille \
    --repository=container-slides \
    --branch master \
    --path 140_gitops/flux2/state \
    --private=false \
    --personal=true
