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

XXX check for jobs

## Task 4: Check logs

XXX check for jobs

## Task 5: Deploy demo application

XXX podinfo

XXX https://github.com/stefanprodan/podinfo

```shell
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update
```

XXX

```shell
helm --namespace=default upgrade \
    --install \
    --set replicaCount=2 \
    --set backend=http://backend-podinfo:9898/echo \
    frontend podinfo/podinfo \
        --set=extraEnvs[0].name=OTEL_EXPORTER_OTLP_TRACES_ENDPOINT \
        --set=extraEnvs[0].value=http://tempo.monitoring:4317
```

XXX

```shell
helm --namespace=default test \
    frontend
```

XXX

```shell
helm --namespace=default upgrade \
    --install \
    --set redis.enabled=true \
    backend podinfo/podinfo \
        --set=extraEnvs[0].name=OTEL_EXPORTER_OTLP_TRACES_ENDPOINT \
        --set=extraEnvs[0].value=http//tempo.monitoring:4317
```

XXX create port forwarding

## Task 5: Application-Level metrics

XXX checkout `ServiceMonitor`

XXX check data

## Task 6: Working with traces

XXX
