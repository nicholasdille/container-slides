#!/bin/bash
set -o errexit

# Create cluster
if ! kind get clusters | grep --quiet argocd; then
    kind create cluster --name argocd --config kind.yaml
    kind get kubeconfig --name argocd >${HOME}/.kube/config.kind-argocd
fi
export KUBECONFIG=${HOME}/.kube/config.kind-argocd

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

# Deploy ArgoCD
if ! kubectl get namespace argocd >/dev/null 2>&1; then
    kubectl create namespace argocd
fi
kubectl apply --namespace argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl --namespace argocd rollout status statefulset argocd-application-controller
kubectl --namespace argocd rollout status deployment argocd-dex-server
kubectl --namespace argocd rollout status deployment argocd-redis
kubectl --namespace argocd rollout status deployment argocd-repo-server
kubectl --namespace argocd rollout status deployment argocd-server

# Install CLI
if ! type argocd >/dev/null 2>&1; then
    curl -sLo /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.0.3/argocd-linux-amd64
    chmod +x /usr/local/bin/argocd
fi
eval "$(argocd completion bash)"
