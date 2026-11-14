# LGTM Stack

XXX prerequisites: VM works, vscode is accessible, k8s is accessible

XXX GMLT ;-)

## Prep

```shell
helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Task 1: Deploy Grafana

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    grafana grafana-community/grafana
```

XXX extract admin password

XXX access web UI

## Task 2: Deploy Mimir

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    mimir grafana/mimir-distributed \
        --values=values-mimir.yaml
```

XXX add data source in Grafana

## Task 3: Deploy Loki

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    loki grafana-community/loki \
        --values=values-loki.yaml
```

XXX add data source in Grafana

## Task 4: Deploy Tempo

XXX helm

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    tempo grafana-community/tempo \
        --values=values-tempo.yaml
```

XXX add data source in Grafana
