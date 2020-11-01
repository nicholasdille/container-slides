#!/bin/bash
set -o errexit

# Create cluster
if ! kind get clusters | grep --quiet gotk; then
    kind create cluster --name gotk --config kind.yaml
fi

# If the cluster is running on a remote Docker host
if test "$(docker context ls | grep '*' | cut -d' ' -f1)" != "default"; then
    SERVER=$(
        kubectl config view --output json | \
            jq --raw-output '
                .clusters[] |
                select(.name == "kind-gotk") |
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
curl -s https://pkg.dille.io/flux/install.sh | bash
source /usr/local/etc/bash_completion.d/flux.sh

# Deploy flux2
flux bootstrap github \
    --owner=nicholasdille \
    --repository=container-slides \
    --branch master \
    --path 140_gitops/flux2/state \
    --private=false \
    --personal=true
