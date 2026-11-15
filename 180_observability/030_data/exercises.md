# Data Collection

This exercise will start collecting data from the cluster.

## Preparation

You will deploy more helm charts. Make sure your `helm` knows about the necessary repositories:

```shell
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

## Task 1: Metrics Server

The Kubernetes `metrics-server` plugs into the metrics API and collects resource usage data from the nodes and pods in the cluster. The data can be used from tools like `kubectl top` to monitor resource usage in real-time. In addition it enables the horizontal pod autoscaler to scale deployments based on resource usage.

```shell
helm --namespace=monitoring upgrade \
    --install \
    metrics-server metrics-server/metrics-server \
        --set=args[0]=--kubelet-insecure-tls
```

Check out the metrics collected by the metrics server using `kubectl top pods` in the different namespaces.

## Task 2: Tap existing data sources

When replacing Prometheus with modern components, you need to install the custom resource definitions (CRDs) for the Prometheus operator first. The are the defacto standard for declaring scrape targets metrics collection:

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    prometheus-operator-crds prometheus-community/prometheus-operator-crds
```

Grafana has consilidated the collection of metrics and logs from cluster components into a single uber-chart. This simplifies deployment but is rather complex to configure.

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    k8s-monitoring grafana/k8s-monitoring --values values-k8s-monitoring.yaml
```

The values for the helm chart are available as file: `container-slides/180_observability/030_data/values-k8s-monitoring.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/030_data/values-k8s-monitoring.yaml).

## Milestone

Observability data will now flow from cluster components into the LGTM stack.

## Task 3: Check metrics

XXX

```promql
cortex_distributor_received_samples_total
```

## Task 4: Check logs

XXX

```promql
loki_distributor_lines_received_total
```

## Task 5: Deploy demo application

`podinfo` is a demo application that showcases various Kubernetes features such as deployments, services, and observability integrations: https://github.com/stefanprodan/podinfo.

You will deploy another helm chart for a demo application. Make sure your `helm` knows about the necessary repositories:

```shell
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update
```

Deploy the frontend of the demo application:

```shell
helm --namespace=default upgrade \
    --install \
    --set replicaCount=2 \
    --set backend=http://backend-podinfo:9898/echo \
    frontend podinfo/podinfo \
        --set=serviceMonitor.enabled=true \
        --set=extraEnvs[0].name=OTEL_EXPORTER_OTLP_TRACES_ENDPOINT \
        --set=extraEnvs[0].value=http://tempo.monitoring:4317
```

Test that the frontend is working correctly:

```shell
helm --namespace=default test \
    frontend
```

Deploy the backend of the demo application:

```shell
helm --namespace=default upgrade \
    --install \
    --set redis.enabled=true \
    backend podinfo/podinfo \
        --set=serviceMonitor.enabled=true \
        --set=extraEnvs[0].name=OTEL_EXPORTER_OTLP_TRACES_ENDPOINT \
        --set=extraEnvs[0].value=http://tempo.monitoring:4317
```

XXX create port forwarding

```shell
kubectl --namespace=default port-forward svc/frontend-podinfo 9898:9898
```

XXX open https://9898.seatN.inmylab.de

## Task 5: Application-Level metrics

`podinfo` ships with a `ServiceMonitor` for exposing application-level metrics. Such a resource is automatically scraped by `alloy`.

Check out the `ServiceMonitor` for the frontend of the `podinfo` application:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: frontend-podinfo
spec:
  endpoints:
  - interval: 15s
    path: /metrics
    port: http
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app.kubernetes.io/name: frontend-podinfo
```

Check out the `ServiceMonitor` for the backend of the `podinfo` application:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: backend-podinfo
spec:
  endpoints:
  - interval: 15s
    path: /metrics
    port: http
  namespaceSelector:
    matchNames:
    - default
  selector:
    matchLabels:
      app.kubernetes.io/name: backend-podinfo
```

XXX check data

```promql
scrape_samples_scraped{job="frontend-podinfo"}
```

## Task 6: Working with traces

XXX

```promql
tempo_distributor_spans_received_total
```
