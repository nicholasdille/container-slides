# Alerts

!!! goal "Goal"
    In this project you will learn how to set up and test alerts in Grafana.

    Afterwards you will get to know the Alertmanager and declarative alerting:

    - Install and configure the Alertmanager declaratively
    - Trigger test alerts and observe their delivery
    - Declare alerts as `PrometheusRule` and have them evaluated

!!! tipp "Resources"

    - Try to solve the tasks on your own. Each task has a collapsible block with a suggested solution in case you get stuck.

## Task 1: Create a receiver for alerts

Create a simple HTTP echo server deployment and service in the `monitoring` namespace. This will be used later as a webhook receiver for the Alertmanager.

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin-echo
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpbin-echo
  template:
    metadata:
      labels:
        app: httpbin-echo
    spec:
      containers:
      - name: httpbin
        image: mccutchen/go-httpbin
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: httpbin-echo
  namespace: monitoring
spec:
  selector:
    app: httpbin-echo
  ports:
  - port: 8080
```

Create a port forwarding for `svc/httpbin-echo:8080` using `kubectl`:

```shell
kubectl --namespace=monitoring port-forward svc/httpbin-echo 8080:8080
```

Test sending a manual webhook request to test the webhook receiver:

```shell
curl -s -XPOST http://localhost:8080/post \
    --header 'Content-Type: application/json' \
    --data '{"message": "Hello, world!"}'
```

Now check the logs of the `httpbin-echo` pod to see if the webhook request was received:

```shell
kubectl --namespace=monitoring logs -l app=httpbin-echo
```

### Task 2: Install Alertmanager

Create a file `alertmanager.yaml` with the following content. Replace the smarthost with the value determined in Task 2.1:

```yaml
config:
  enabled: true

  global: {}

  receivers:
  - name: webhook-echo
    webhook_configs:
    - url: http://httpbin-echo.monitoring:8080/post
      send_resolved: true

  route:
    group_wait: 10s
    group_interval: 5m
    receiver: webhook-echo
    repeat_interval: 3h
    routes:
    - matchers: ['severity="critical"']
      receiver: webhook-echo
      group_wait: 0s
      repeat_interval: 1h

  inhibit_rules:
  - source_matchers: ['severity="critical"']
    target_matchers: ['severity="warning"']
    equal: ['alertname']
```

Install the Alertmanager with this configuration:

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm --namespace=monitoring upgrade \
    --install \
    alertmanager prometheus-community/alertmanager \
        --values values_alertmanager.yaml \
        --values alertmanager.yaml
```

??? help "Solution (Click on the arrow if you are stuck)"

    The route is deliberately kept simple here: All alerts go to the receiver `shop-mail`, which sends an email via Mailpit. Alerts with the label `team="debug"` go to the receiver `webhook-echo` instead. Check the installation with `kubectl --namespace=monitoring get pods`. The pod should be `Running`. You can check the applied configuration in the ConfigMap `alertmanager` under the key `alertmanager.yaml`.

### Task 3: Trigger a test alert

The Alertmanager accepts alerts via a REST API. First create a port-forward:

```shell
kubectl --namespace=monitoring port-forward svc/alertmanager 9093:9093
```

Trigger a test alert:

```shell
curl -s -XPOST http://localhost:9093/api/v2/alerts \
    --header 'Content-Type: application/json' \
    --data '[{
      "labels": {
        "alertname": "DiskAlmostFull",
        "team": "shop",
        "severity": "warning",
        "instance": "node-1"
      },
      "annotations": {
        "summary": "Disk usage above 90% on node-1"
      }
    }]'
```

Observe the alert:

- Open the Alertmanager UI at `http://localhost:9093` and take a look at the alert
- View alert in webhook receiver

## Task 4: Declarative alerts with PrometheusRule

Alerts do not have to be maintained in a UI. They can be managed as a Kubernetes resource (`PrometheusRule`) to be evaluated automatically.

Create a file `demo-alert.yaml` with the following content:

```yaml
---
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: demo-alerts
  namespace: monitoring
spec:
  groups:
  - name: demo
    limit: 10
    rules:
    - alert: DemoAlert
      expr: vector(1)
      for: 1m
      keep_firing_for: 5m
      labels:
        team: shop
        severity: warning
      annotations:
        summary: Demo alert for testing the alerting pipeline
        description: This alert is always active (value {{ $value }})
```

The expression `vector(1)` always returns a result greater than `0` - so the alert is guaranteed to fire. Apply the file:

```shell
kubectl apply -f demo-alert.yaml
```

Take a look at the alert in Alertmanager. Then remove this alert:

```shell
kubectl delete -f demo-alert.yaml
```

### A second example: CPU usage relative to the limit

Real alerts are based on actual metrics. Create a file `pod-cpu-alert.yaml` with the following content:

```yaml
---
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: pod-cpu-alerts
  namespace: monitoring
spec:
  groups:
  - name: podinfo
    rules:
    - alert: PodHighCPUUsage
      expr: |
        100 * rate(container_cpu_usage_seconds_total{container!="", container!="POD"}[5m])
          / on (namespace, pod, container)
          kube_pod_container_resource_limits{resource="cpu"}
        > 80
      for: 5m
      labels:
        team: shop
        severity: critical
      annotations:
        summary: Pod {{ $labels.pod }} uses {{ printf "%.0f" $value }}% of its CPU limit
        description: Container {{ $labels.container }} in namespace {{ $labels.namespace }} uses more than 80% of its CPU limit
```

The expression divides the CPU usage of each container by its CPU limit and compares the result to 80%. The matcher `container!=""` filters out metrics without a container, and `container!="POD"` filters out the aggregated pod metrics. The `on (namespace, pod, container)` clause joins the usage series with the matching limit series. Because the condition must hold for `for: 5m`, short spikes do not trigger the alert.

Note that the Alertmanager routes alerts with `severity="critical"` to the `webhook-echo` receiver with `group_wait: 0s` and `repeat_interval: 1h` - this alert therefore appears in the webhook sooner than the warning demo alert. Apply the file:

```shell
kubectl apply -f pod-cpu-alert.yaml
```

To see the alert fire, a pod has to actually approach its CPU limit. Check the value of the expression in Explore with the PromQL query above (without the `> 80`).

```shell
kubectl delete -f pod-cpu-alert.yaml
```
