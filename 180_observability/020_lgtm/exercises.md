# LGTM Stack

XXX prerequisites: VM works, vscode is accessible, k8s is accessible

XXX MLTG ;-)

XXX Looks good to me

## Prep

```shell
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Task 1: Deploy Mimir

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    mimir grafana/mimir-distributed \
        --values=values-mimir.yaml
```

XXX wait for ready pods

## Task 2: Deploy Loki

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    loki grafana-community/loki \
        --values=values-loki.yaml
```

XXX wait for ready pods

## Task 3: Deploy Tempo

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    tempo grafana-community/tempo \
        --values=values-tempo.yaml
```

XXX wait for ready pods

## Task 4: Check datasources in Grafana

XXX

## Task 5: Deploy Grafana

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    grafana grafana-community/grafana \
        --values=values-grafana.yaml
```

XXX port forwarding using vscode

XXX access web UI (admin:admin)
