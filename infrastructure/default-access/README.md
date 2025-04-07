# Access

## Prepare

XXX

```shell
export HETZNER_DNS_API_KEY
```

## DNS

Deploy external-dns:

```shell
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
kubectl create namespace external-dns
kubectl --namespace=external-dns create secret generic hetzner-dns-api-key \
    --from-literal=api-key=${HETZNER_DNS_API_KEY}
helm upgrade --install --namespace external-dns --create-namespace \
    external-dns external-dns/external-dns \
        --values values-external-dns.yaml \
        --skip-schema-validation
```

## Certificates

TODO: Migrate to user-managed cert-manager https://cluster-api.sigs.k8s.io/clusterctl/configuration.html?highlight=cert-manager#migrating-to-user-managed-cert-manager

Deploy cert-manager:

```shell
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
```

## Ingress controller

Deploy traefik:

```shell
helm upgrade --install --namespace traefik --create-namespace \
    traefik traefik/traefik \
        --values values-traefik.yaml
```

Deploy traefik dashboard:

```shell
kubectl apply -f traefik.yaml
```

## Application

Deploy podinfo:

```shell
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm upgrade --install --namespace podinfo --create-namespace \
    podinfo podinfo/podinfo
kubectl apply -f podinfo.yaml
```
