## PromQL

Data types

- **Range vector** for many metrics over a range of timestamps
- **Instant vector** for many metrics for a single timestamp
- **Scalar**
- **String**

Many aggregators [](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators), e.g.

- `count`, `sum`, `min`, `max`, `avg`
- `stddev`, `stdvar`, `quantile`
- `topk`, `bottomk`

Many builtin functions [](https://prometheus.io/docs/prometheus/latest/querying/functions/), e.g.

- `rate()`
- `round()`, `floor()`, `ceil()`

Notes:
promtool [](https://github.com/prometheus/prometheus/tree/main/cmd/promtool)
PromQL CLI [](https://github.com/nalbury/promql-cli)

---

## PromQL: Working with gauges

Gauges represents a value that can arbitrarly jump up and down

Usually used for temperatures or memory usage

Queries:

```plaintext
# Explore container memory
container_memory_usage_bytes
container_memory_usage_bytes{namespace="ingress-nginx"}
container_memory_usage_bytes{namespace="ingress-nginx",container!=""}

# Show memory usage per pod
avg by (pod) (container_memory_usage_bytes{namespace="kube-system",container!=""})

# Show memory usage for a namespace
sum(container_memory_usage_bytes{namespace="kube-system",container!=""})

# Show memory usage for all namespaces
sum by (namespace) (container_memory_usage_bytes{container!=""})
```

---

## PromQL: Working with counters

Counters represent a cumulative value

Usually used for the number of requests served or the CPU usage

Queries:

```plaintext
# Explore counter
container_cpu_usage_seconds_total{namespace="ingress-nginx",container!=""}

# Show rate of change with different resolutions
rate(container_cpu_usage_seconds_total{namespace="ingress-nginx",container!=""}[5m])
rate(container_cpu_usage_seconds_total{namespace="ingress-nginx",container!=""}[10m])

# Idle node CPU
node_cpu_seconds_total{mode="idle"}
rate(node_cpu_seconds_total{mode="idle"}[5m])
sum by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]))
```

---

## PromQL: Fun with kube-state-metrics

kube-state-metrics creates additional metrics from cluster state information

Queries:

```plaintext
# Error reasons for pods
count by (reason) (kube_pod_status_reason)
count by (reason) (kube_pod_container_status_terminated_reason)

# Number of replicas
count by (exported_container) (kube_pod_container_status_ready)

# Numer of running pods
count(count by (exported_container) (kube_pod_container_status_running))

# Pods referencing Helm chart
count by (exported_pod) (
    kube_pod_labels{label_chart!=""} or
    kube_pod_labels{label_helm_sh_chart!=""}
)
```

---

## PromQL tips and tricks

### container="POD"

You are using `dockershim` (Docker runtime)

Filter out sleeping POD container:

```plaintext
container_memory_usage_bytes{namespace="ingress-nginx",container!="",container!="POD"}
```

### `kube_pod_labels` is empty

`kube-state-metrics` does not aggregate labels anymore [#1501](https://github.com/kubernetes/kube-state-metrics/issues/1501)

Set `--metric-labels-allowlist=pods=[*]` in arguments

Or `metricLabelsAllowlist` in Helm chart [](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-state-metrics/values.yaml#L184)
