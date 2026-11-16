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

XXX port-forwarding for svc/httpbin-echo:8080

```shell
kubectl --namespace=monitoring port-forward svc/httpbin-echo 8080:8080
```

XXX test

```shell
curl -s -XPOST http://localhost:8080/post \
    --header 'Content-Type: application/json' \
    --data '{"message": "Hello, world!"}'
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
```

Install the Alertmanager with this configuration:

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm --namespace=monitoring upgrade \
    --install \
    alertmanager prometheus-community/prometheus-alertmanager \
        --values values_alertmanager.yaml \
        --values alertmanager.yaml
```

??? help "Solution (Click on the arrow if you are stuck)"

    The route is deliberately kept simple here: All alerts go to the receiver `shop-mail`, which sends an email via Mailpit. Alerts with the label `team="debug"` go to the receiver `webhook-echo` instead. Check the installation with `kubectl --namespace=monitoring get pods`. The pod should be `Running`. You can check the applied configuration in the ConfigMap `alertmanager` under the key `alertmanager.yaml`.

### Task 2.3 - Trigger a test alert

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
- Open Mailpit and watch the incoming email

Trigger the same alert again and observe:

- The labels are identical → the Alertmanager recognizes the duplicate and sends **no** second email (deduplication)
- Change `instance` to `node-2` and trigger again → both alerts are bundled into **one** notification (grouping)

??? help "Solution (Click on the arrow if you are stuck)"

    Deduplication is based on the identity of an alert, i.e. its labels. Grouping is controlled via `group_by`: alerts with the same `alertname` and `team` end up in the same group and are sent together. `group_wait: 0s` ensures that the first notification goes out immediately.

### Task 2.4 - Silence an alert

Create a silence in the Alertmanager UI:

- Open `http://localhost:9093`
- Select the alert `DiskAlmostFull` and click **Silence**
- Duration: `1h`, creator and comment of your choice
- Trigger the alert again and observe: no more email arrives
- The alert remains visible in the UI but is marked as silenced

??? help "Solution (Click on the arrow if you are stuck)"

    Silences are matchers on labels, here by default `alertname="DiskAlmostFull"`. You can find them in the Alertmanager UI under **Silences**. From there they can also be ended ahead of time.

## Task 3 - Declarative alerts with PrometheusRule

Alerts do not have to be maintained in a UI. The Prometheus operator can manage alerts as a Kubernetes resource (`PrometheusRule`), and Prometheus evaluates them automatically.

### Task 3.1 - Install the Prometheus operator

In the exercise `030_data` the CRDs have already been installed. Now add the operator itself, which manages the objects:

```shell
curl -sSLf https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.81.0/bundle.yaml \
    | sed 's/^  namespace: default/  namespace: monitoring/' \
    | kubectl apply --server-side --filename=-
```

Check that the operator is running:

```shell
kubectl --namespace=monitoring get pods
```

??? help "Solution (Click on the arrow if you are stuck)"

    The pod is called `prometheus-operator-...` and should be `Running`. If the operator is already installed, `kubectl apply` is idempotent and the command changes nothing.

### Task 3.2 - Declare the Prometheus instance

Prometheus itself is also operated declaratively as a CRD. Create a file `prometheus.yaml` with the following content:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources: [pods, services, endpoints]
  verbs: [get, list, watch]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
---
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
  namespace: monitoring
spec:
  serviceAccountName: prometheus
  ruleSelector: {}
  evaluationInterval: 30s
  alerting:
    alertmanagers:
    - namespace: monitoring
      name: alertmanager
      port: 9093
```

Apply the file:

```shell
kubectl apply --filename=prometheus.yaml
```

Two settings are important here:

- `ruleSelector: {}`: Prometheus accepts **all** `PrometheusRule` objects in the namespace
- `alerting`: Firing alerts are forwarded to the Alertmanager from Task 2

??? help "Solution (Click on the arrow if you are stuck)"

    The operator creates a StatefulSet with the pod `prometheus-prometheus-0` from this. Check with `kubectl --namespace=monitoring get prometheus` and `kubectl --namespace=monitoring get pods`.

### Task 3.3 - Declare an alert

Create a file `demo-alert.yaml` with the following content:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: demo-alerts
  namespace: monitoring
spec:
  groups:
  - name: demo
    rules:
    - alert: DemoAlert
      expr: vector(1)
      for: 1m
      labels:
        team: shop
        severity: warning
      annotations:
        summary: Demo alert for testing the alerting pipeline
        description: This alert is always active (value {{ $value }})
```

The expression `vector(1)` always returns a result greater than `0` - so the alert is guaranteed to fire. Apply the file:

```shell
kubectl apply --filename=demo-alert.yaml
```

??? help "Solution (Click on the arrow if you are stuck)"

    Check that the object exists: `kubectl --namespace=monitoring get prometheusrule`. The operator passes the rule on to Prometheus; you can trace this in the generated configuration using `kubectl --namespace=monitoring get prometheus -o yaml`.

### Task 3.4 - Observe the alert status

Create a port-forward for Prometheus:

```shell
kubectl --namespace=monitoring port-forward svc/prometheus-operated 9090:9090
```

Observe the lifecycle of the alert at `http://localhost:9090/alerts`:

- First `Pending`: The condition is met but `for: 1m` is not yet fulfilled
- After one minute `Firing`: The alert is forwarded to the Alertmanager
- In the Alertmanager UI (`http://localhost:9093`), `DemoAlert` appears with the labels `team=shop` and `severity=warning`
- The notification arrives in Mailpit

Then delete the rule and observe how the alert switches to `Inactive` and is marked as `Resolved` in the Alertmanager:

```shell
kubectl delete --filename=demo-alert.yaml
```

??? help "Solution (Click on the arrow if you are stuck)"

    The lifecycle is: `inactive` → `pending` → `firing`. `for` prevents flapping: short-term outliers do not trigger an alarm. Only firing alerts are sent to the Alertmanager, which decides via the route from Task 2 who gets notified.
