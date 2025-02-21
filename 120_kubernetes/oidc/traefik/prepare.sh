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

if test -f .env; then
    source .env
fi
if test -z "${HETZNER_DNS_API_KEY}"; then
    echo "Please provide the Hetzner DNS API key in HETZNER_DNS_API_KEY"
    exit 1
fi

helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
kubectl create namespace external-dns
kubectl --namespace=external-dns create secret generic hetzner-dns-api-key \
    --from-literal=api-key=${HETZNER_DNS_API_KEY}
helm upgrade --install --namespace external-dns --create-namespace \
    external-dns external-dns/external-dns \
        --values values-external-dns.yaml

helm repo add cert-manager https://charts.jetstack.io
helm repo add cert-manager-webhook-hetzner https://vadimkim.github.io/cert-manager-webhook-hetzner
helm upgrade --install --namespace cert-manager --create-namespace \
    cert-manager cert-manager/cert-manager \
        --values values-cert-manager.yaml
kubectl --namespace=cert-manager create secret generic hetzner-dns-api-key \
    --from-literal=api-key=${HETZNER_DNS_API_KEY}
helm upgrade --install --namespace cert-manager --create-namespace \
    cert-manager-webhook-hetzner cert-manager-webhook-hetzner/cert-manager-webhook-hetzner \
        --set groupName=acme.inmylab.de \
        --set secretName={hetzner-dns-api-key}
kubectl apply -f cert-manager.yaml

helm upgrade --install --namespace traefik --create-namespace \
    traefik traefik/traefik \
        --values values-traefik.yaml

kubectl --namespace=cert-manager create secret generic hetzner-dns-api-key \
    --from-literal=api-key=${HETZNER_DNS_API_KEY}
kubectl apply -f traefik.yaml

helm repo add dex https://charts.dexidp.io
helm upgrade --install --namespace dex --create-namespace \
    dex dex/dex \
        --values values-dex.yaml
kubectl apply -f dex.yaml

curl -L -X POST 'https://dex.inmylab.de/dex/token' \
-H 'Authorization: Basic cHVibGljLWNsaWVudAo=' \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'scope=openid profile' \
--data-urlencode 'username=admin@inmylab.de' \
--data-urlencode 'password=admin'

curl -L -X POST 'https://dex.inmylab.de/dex/token' \
-H 'Authorization: Basic cHJpdmF0ZS1jbGllbnQ6YXBwLXNlY3JldAo=' \ # base64 encoded: private-client:app-secret
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'scope=openid' \
--data-urlencode 'username=admin@example.com' \
--data-urlencode 'password=admin'

helm repo add oauth2-proxy https://oauth2-proxy.github.io/manifests
helm upgrade --install --namespace oauth2-proxy --create-namespace \
    oauth2-proxy oauth2-proxy/oauth2-proxy \
        --values values-oauth2-proxy.yaml
kubectl apply -f oauth2-proxy.yaml

helm repo add podinfo https://stefanprodan.github.io/podinfo
helm upgrade --install --namespace podinfo --create-namespace \
    podinfo podinfo/podinfo
kubectl apply -f podinfo.yaml
