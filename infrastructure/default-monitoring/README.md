## Monitoring

Create namespace:

```shell
kubectl create namespace monitoring
```

Deploy prometheus-operator:

```shell
kubectl create namespace monitoring

curl -sSLf https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.81.0/bundle.yaml \
| sed 's/^  namespace: default/  namespace: monitoring/' \
| kubectl apply --server-side --filename=-
kubectl apply --filename=prometheus.yaml
```

Deploy loki:

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install --namespace=monitoring loki grafana/loki --values=loki-values.yaml
```

Deploy data collection:

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install --namespace=monitoring k8s-monitoring grafana/k8s-monitoring --values=k8s-monitoring-values.yaml
```

Check configuration:
- svc/k8s-monitoring-alloy-logs:12345
- svc/k8s-monitoring-alloy-metrics:12345

Deploy metrics-server:

```shell
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install --namespace=monitoring metrics-server metrics-server/metrics-server
```

Deploy grafana:

```shell
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install --namespace=monitoring grafana grafana/grafana
```
