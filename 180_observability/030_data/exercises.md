# Data Collection

XXX prerequisites

## Prep

```shell
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Task 0: Metrics Server

```shell
helm --namespace=monitoring upgrade \
    --install \
    metrics-server metrics-server/metrics-server \
        --set=args[0]=--kubelet-insecure-tls
```

## Task 1: Tap existing data sources

XXX CRDs

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    prometheus-operator-crds prometheus-community/prometheus-operator-crds
```

XXX helm k8s-monitoring

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    k8s-monitoring grafana/k8s-monitoring --values values-k8s-monitoring.yaml
```

XXX check sources

XXX check data in Grafana

## Task 2: Check metrics

XXX

## Task 3: Check logs

XXX

## Task 4: Check traces

XXX

## Task 5: Application-Level data

XXX podinfo?

```shell
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm --namespace=default upgrade \
    --install \
    my-otel-demo open-telemetry/opentelemetry-demo \
        --values=values-otel-demo.yaml
```
