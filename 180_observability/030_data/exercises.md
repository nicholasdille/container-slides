# Data Collection

This exercise will start collecting data from the cluster.

## Preparation

You will deploy more helm charts. Make sure your `helm` knows about the necessary repositories:

```shell
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
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

Grafana has consilidated the collection of metrics and logs from cluster components into a single uber-chart. This simplifies deployment but is rather complex to configure.

```shell
helm --namespace=monitoring upgrade \
    --install \
    --create-namespace \
    k8s-monitoring grafana/k8s-monitoring \
        --values=container-slides/180_observability/030_data/values-k8s-monitoring.yaml
```

The values for the helm chart are available as file: `container-slides/180_observability/030_data/values-k8s-monitoring.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/030_data/values-k8s-monitoring.yaml).

## Milestone

Observability data will now flow from cluster components into the LGTM stack.

## Task 3: Check metrics

Go to the `Explore` view in Grafana, switch to the datasource `Mimir` and plot the following query to view the number of metric samples received by Mimir:

```promql
cortex_distributor_samples_in_total
```

The metric is a counter and should increase every few seconds.

## Task 4: Check logs

Go to the `Explore` view in Grafana, switch to the datasource `Mimir` and plot the following query to view the number of lines received by Loki:

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
        --set=extraEnvs[0].value=http://tempo.monitoring:4317 \
        --set=extraArgs[0]=--otel-service-name=podinfo-frontend
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
        --set=extraEnvs[0].value=http://tempo.monitoring:4317 \
        --set=extraArgs[0]=--otel-service-name=podinfo-backend
```

## Task 6: Create a port forwarding

First, create a port forwarding using `kubectl` to interact with `podinfo`:

```shell
kubectl --namespace=default port-forward svc/frontend-podinfo 9898:9898
```

Now, open `https://9898.seatN.inmylab.de` where N is your seat number.

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

Check that data is being received for `podinfo` by running the following query:

```promql
scrape_samples_scraped{job="frontend-podinfo"}
```

## Task 7: Deploy k6-operator

The `k6-operator` allows running distributed load tests using `k6` inside the cluster: https://github.com/grafana/k6-operator. Tests are described as `TestRun` resources and the operator takes care of spinning up the required pods.

The `grafana` helm repository from the preparation above already contains the chart for the operator. Deploy it with the `ServiceMonitor` enabled so that the operator's metrics are scraped by `alloy`:

```shell
helm --namespace=k6-operator-system \
    --create-namespace \
    upgrade \
    --install \
    k6-operator grafana/k6-operator \
        --set=metrics.serviceMonitor.enabled=true
```

Check that the operator is up and running:

```shell
kubectl --namespace=k6-operator-system get pods
```

## Task 8: Run a load test

Now that the operator is running, deploy a load test against the frontend of the `podinfo` application. The test starts 10 parallel users requesting random status codes in an endless loop with a random delay between 2 and 5 seconds.

The `TestRun` resource and the `k6` script are available as file: `container-slides/180_observability/030_data/podinfo-load-test.yaml`. You can also view it in a web browser [in the repository on Gitub](https://github.com/nicholasdille/container-slides/blob/master/180_observability/030_data/podinfo-load-test.yaml).

```shell
kubectl apply -f podinfo-load-test.yaml
```

The operator will spin up a runner pod to execute the test:

```shell
kubectl --namespace=default get pods -l k6_cr=podinfo-load-test -w
```

The runner sends the k6 metrics to Mimir using the Prometheus remote write protocol. Check that the load test is running by opening the `Explore` view in Grafana, switching to the datasource `Mimir` and plotting the following query:

```promql
sum(rate(k6_http_reqs_total{job="podinfo-load-test"}[1m]))
```

The requests are tagged with the HTTP status code so the distribution can be verified using the following query:

```promql
sum by (status) (rate(k6_http_reqs_total{job="podinfo-load-test"}[1m]))
```
