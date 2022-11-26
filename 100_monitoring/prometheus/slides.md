## Agenda topics

- <span class="fa-li"><i class="fa-duotone fa-binoculars"></i></span> Observability *o11y*
- <span class="fa-li"><i class="fa-duotone fa-person-dolly-empty"></i></span> Collection strategies
- <span class="fa-li"><i class="fa-duotone fa-layer-group"></i></span> Layers of Monitoring
- <span class="fa-li"><i class="fa-duotone fa-chart-line"></i></span> Visualization
- <span class="fa-li"><i class="fa-duotone fa-person-chalkboard"></i></span> Lessons Learnt from Monitoring

<!-- .element: class="fa-ul" -->

---

## o11y

Observability helps understanding a system from the outside

It consists of three pillars

### <i class="fa-duotone fa-chart-line"></i> Metrics

Quantative measures of performance data

### <i class="fa-duotone fa-file-lines"></i> Logs

Protocol of status information and events during runtime

### <i class="fa-duotone fa-shoe-prints"></i> Distributed Traces

Metadata for status information

Connect protocols across services

---

## Metric sources

![](100_monitoring/prometheus/layers.drawio.svg)<!-- .element: style="width: 50%;" -->

<!-- .element: style="width: 90%;" -->

---

## Collection strategies

How metrics can be collected...

![](100_monitoring/prometheus/push.drawio.svg) <!-- .element: style="width: 45%; float: right;" -->

### Push <i class="fa-duotone fa-truck"></i>

Metrics are delivered to database

Usually involves an agent

Example: Telegraf agent and InfluxDB

### Pull <i class="fa-duotone fa-hand-holding-heart"></i>

![](100_monitoring/prometheus/pull.drawio.svg) <!-- .element: style="width:45%; float: right;" -->

Database scrapes metrics

Either app-integrated or sidecar pattern

Example: Exporters and Prometheus

---

## Scope

![](100_monitoring/prometheus/logo.svg) <!-- .element: style="float: right; width: 4em;" -->

Prometheus [](https://prometheus.io/) for cloud native monitoring

Graduated project of CNCF [](https://www.cncf.io/projects/prometheus/)

### Internals

![](100_monitoring/prometheus/prometheus.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Exporters offer metrics for retrieval

Prometheus scrapes data from exporters

Metrics are stored in a time series database (TSDB)

Query language PromQL

---

## Container metrics primer

Collecting metrics for containers

Containers are based on cgroups

Start a container and retrieve ID:

```bash
docker run -d --name nginx nginx
ID="$(docker container inspect nginx | jq -r '.[].Id')""
```

Using high-level tools:

```bash
docker stats
systemd-cgtop
```

Directly from the kernel:

```bash
cat "/sys/fs/cgroup/pids/docker/${ID}/cgroup.procs"
cat "/sys/fs/cgroup/cpuacct/docker/${ID}/cpuacct.usage"
cat "/sys/fs/cgroup/memory/docker/${ID}/memory.usage_in_bytes"
```

---

## Container metrics in Kubernetes

Remember: `kubelet` is responsible for maintaining pods/containers on a node

kubelet collects metrics

Published under /metrics/cadvisor/

`kubectl top` requires metrics server https://github.com/kubernetes-sigs/metrics-server/

---

## Demo: Container metrics in Kubernetes 1/

Explore metrics using `kubeletctl` [](https://github.com/cyberark/kubeletctl)

```bash
IP="$(
    docker inspect \
        --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
        kind-worker
)"
TOKEN="$(
    kubectl get secrets kubelet -o json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl get secrets kubelet -o json \
| jq --raw-output '.data."ca.crt"' \
| base64 -d >ca.crt
kubeletctl \
    --server ${IP} \
    --cacert ca.crt \
    --token ${TOKEN} \
    metrics cadvisor | less
```

---

## Demo: Container metrics in Kubernetes 2/

Explore metrics using `curl`

```bash
IP="$(
    docker inspect \
        --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\
        kind-worker
)"
TOKEN="$(
    kubectl get secrets kubelet -o json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl get secrets kubelet -o json \
| jq --raw-output '.data."ca.crt"' \
| base64 -d >ca.crt
curl -skH "Authorization: Bearer ${TOKEN}" \
    "https://${IP}:10250/metrics/cadvisor" | less
curl -skH "Authorization: Bearer ${TOKEN}" \
    "https://${IP}:10250/metrics/cadvisor" | grep container_memory_usage_bytes | grep kube-proxy
```

---

## OpenMetrics 1/

"...today's de-facto standard for transmitting cloud-native metrics at scale." [](https://openmetrics.io/)

### Types


- <span class="fa-li"><i class="fa-duotone fa-gauge-high"></i></span> Gauge
- <span class="fa-li"><i class="fa-duotone fa-arrow-down-1-9"></i></span> Counter
- <span class="fa-li"><i class="fa-duotone fa-chart-column"></i></span> Histogram
- <span class="fa-li"><i class="fa-duotone fa-ball-pile"></i></span> and more [](https://github.com/OpenObservability/OpenMetrics/blob/main/specification/OpenMetrics.md#metric-types)

<!-- .element: class="fa-ul" -->

### Metadata

Metrics can have labels

Labels provide metadata for filtering

---

## OpenMetrics 2/

Example output of a metrics endpoint:

```plaintext
# TYPE acme_http_router_request_seconds summary
# UNIT acme_http_router_request_seconds seconds
# HELP acme_http_router_request_seconds Latency though all of ACME's HTTP request router.
acme_http_router_request_seconds_sum{path="/api/v1",method="GET"} 9036.32
acme_http_router_request_seconds_count{path="/api/v1",method="GET"} 807283.0
acme_http_router_request_seconds_created{path="/api/v1",method="GET"} 1605281325.0
acme_http_router_request_seconds_sum{path="/api/v2",method="POST"} 479.3
acme_http_router_request_seconds_count{path="/api/v2",method="POST"} 34.0
acme_http_router_request_seconds_created{path="/api/v2",method="POST"} 1605281325.0
# TYPE go_goroutines gauge
# HELP go_goroutines Number of goroutines that currently exist.
go_goroutines 69
# TYPE process_cpu_seconds counter
# UNIT process_cpu_seconds seconds
# HELP process_cpu_seconds Total user and system CPU time spent in seconds.
process_cpu_seconds_total 4.20072246e+06
```

---

## OpenMetrics

Metrics in Kubernetes have labels for:

- Namespace name
- Pod name
- Container name

For example:

```plaintext
container_memory_usage_bytes{
    namespace="kube-system",
    pod="kube-proxy-68mp4",
    container="kube-proxy",
    # ...
} 1.4917632e+07 1669235346213
```

---

## Host metrics

Can containers use all resources? Yes, but they should not!

Some reservations are necessary [](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)

![](100_monitoring/prometheus/reservations.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

### Operating system

Reserved for system services

### Kubernetes

Reserved for cluster components

### Further resources

Instance calculator for cloud providers [](https://learnk8s.io/kubernetes-instance-calculator)

Read reservations from managed cluster [](https://github.com/learnk8s/kubernetes-resource-inspector)

---

## CPU Reservations in Managed Kubernetes

Major cloud providers agree

| Cores | Reservation    | Cumulative | Efficiency |
|-------|---------------:|-----------:|-----------:|
| 1     |   60m          | 60m        | 94.0%      |
| 2     | + 10m          | 70m        | 96.5%      |
| 4     | + 10m          | 80m        | 98.0%      |
| 8     | + 10m          | 90m        | 99.0%      |

### Rules

6% of first core, 1% of second core, 0.5% of third and fourth core, 0.25% per core > 4

---

## Memory reservations in Managed Kubernetes

Most major cloud providers agree

AWS uses: 255MiB + 11MiB * MAX_PODS

| Memory | Reservation | Cumulative | Efficiency |
|--------|------------:|-----------:|-----------:|
| 0      |   255MiB    | 255MiB     |            |
| 4GiB   | + 800MiB    | 1055MiB    | 73.7%      |
| 8GiB   | + 800GiB    | 1855MiB    | 76,8%      |
| 112GiB | + 672MiB    | 2527MiB    | 97.7%      |
| 128GiB | + 256MiB    | 2783MiB    | 97.8%      |

### Rules

255MiB, 25% of 4GiB, 20% of next 4GiB, 10% of next 8GiB, 6% of next 112GiB, 2% of memory above 128GiB

---

## Configure Reservations

`kubelet` flags:

```plaintext
--system-reserved=memory=500Mi,cpu=100m
--kube-reserved=memory=500Mi,cpu=100m
```

Implementation depends on deployment

For example in `kind`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        system-reserved: memory=12Gi,cpu=2000m
        kube-reserved: memory=100Mi,cpu=100m
```

---

## Host metrics collection

node-exporter [](https://github.com/prometheus/node_exporter) collects host metrics...

...and exports them for scraping

Metrics [](https://github.com/prometheus/node_exporter#collectors) include CPU, memory, disk, network and a lot more!

Some are disabled by default [](https://github.com/prometheus/node_exporter#disabled-by-default)

### Demo

Start Kubernetes API proxy:

```bash
kubectl proxy
```

Read metrics endpoint:

```bash
NS=kube-system
SVC=node-exporter-prometheus-node-exporter
curl -s localhost:8001/api/v1/namespaces/${NS}/services/${SVC}:metrics/proxy/metrics \
| grep node_cpu_seconds_total
```

---

## Cluster metrics

All components provide a metrics endpoint:

- kube-apiserver
- coredns
- kube-controller-manager
- kube-proxy
- kube-scheduler
- kubelet

Prometheus should scrape all of them

---

## metrics-server [](https://github.com/kubernetes-sigs/metrics-server/)

Required for `kubectl top`

Provides an API for metrics collected by kubelet

Required for Horizontal/Vertical Pod AutoScaler

Get node state:

```bash
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/kind-worker | jq
```

Get pod state:

```bash
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/kube-system/pods/etcd-kind-control-plane | jq
```

View table of all nodes:

```bash
kubectl top node
```

View table of all pods in the current namespace:

```bash
kubectl top pod
```

---

### `kube-state-metrics` [](https://github.com/kubernetes/kube-state-metrics)

New metrics about cluster

https://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/

`kubectl proxy`

`curl localhost:8001/api/v1/namespaces/kube-system/services/kube-state-metrics:http/proxy/metrics`

---

## Metrics collection

![](100_monitoring/prometheus/cluster_scraping.drawio.svg) <!-- .element: style="width: 100%;" -->

---

## Scrape configuration

Configure Prometheus to scrape targets [](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)

- Read from app with metrics endpoints
- Read from central exporter which reads from app
- Read from app with exporter sidecar

Small scrape config:

```yaml
scrape_configs:
- job_name: 'example-target-1'
  scrape_interval: 5s
  static_configs:
    - targets: ['localhost:8090']
      labels:
        group: 'dummy'
- job_name: 'example-target-2'
  metrics_path: /api/metrics
  static_configs:
    - targets: ['localhost:8080']
      labels:
        group: 'dummy-2'
```

---

## Prometheus Operator

...because scrape configs are not fun to maintain!

Ships with multiple custom resource definitions:

- `Prometheus` for Prometheus instances

- `ServiceMonitor` for scraping pods behind a service

- `PodMonitor` for scraping individual pods

## Demo

Explore managed instances

Explore (Pod|Service)Monitors for cluster components

View targets in [Prometheus web UI](http://prometheus.inmylab.de)

Test graph in [Prometheus web UI](http://prometheus.inmylab.de)

---

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

---

## Visualization

Grafana is the most prominent tool to query, visualize and alert on metrics

Supports many datasources including Prometheus

Support datasource-specific query language

Prometheus community offers pre-created dashcoards [](https://github.com/kubernetes-monitoring/kubernetes-mixin)

### Demo

Quick intro to UI [](http://grafana.inmylab.de)

Graph for pod memory

Graph for pod CPU (usage)

Graph for node memory

Count running pods

---

## Special exporters

### `blackbox_exporter` [](https://github.com/prometheus/blackbox_exporter)

Probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC

### `json_exporter` [](https://github.com/prometheus-community/json_exporter)

Scraping of remote JSON by JSONPath [](https://goessner.net/articles/JsonPath/)

### `pushgateway` [](https://github.com/prometheus/pushgateway)

Helps with firewall traversal

Accepts metrics from apps or agents [](https://github.com/prometheus/pushgateway#command-line)

Does not remove orphaned metrics

Notes:
http://push.inmylab.de/

---

## Pod Quality-of-Service

Kubernetes will try really hard to protect pods

### Pod eviction

When resources on a node are depleted:

- `kube-scheduler` will stop scheduling pods to the node
- `kubelet` will evict pods

### How pods are "chosen"

Pods have a quiality-of-service based on resource requests and limits [](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)

- Best effort: All container have resource identical requests and limits
- Burstable: At least one container has resource requests or limits
- Guaranteed: All container do not have resource requests or limits

Scheduling uses resource requests to find suitable node

Notes:
Check pods for QoS
`kubectl get pods -A -o json | jq -r '.items[] | "\(.metadata.name): \(.status.qosClass)"'`

---

## Outlook

[Federation](https://prometheus.io/docs/prometheus/latest/federation/) of multiple clusters

Scaling
- [Thanos](https://thanos.io/)
- [Cortex](https://cortexmetrics.io/)
- [Mimir](https://grafana.com/oss/mimir/)

Log shipping
- [ElasticSearch](https://www.elastic.co/)
- [Loki](https://grafana.com/oss/loki/)

Tracing
- [Sentry](https://sentry.io/)
- [Jaeger](https://www.jaegertracing.io/)
- [Tempo](https://grafana.com/oss/tempo/)

Notes:
https://github.com/grafana/agent