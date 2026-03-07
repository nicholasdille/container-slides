## Data Collection

<i class="fa-duotone fa-solid fa-vacuum fa-4x"></i> <!-- .element: style="float: right;" -->

Centralized storage
- Independent of system availability
- Correlation
- Harder to temper with

Layers
- Infrastructure
- Virtualization hosts
- Cluster
- Node
- Pod
- Container
- Application

---

## Existing data sources

Infrastructure

Host OS (Linux)

Node (kubelet, kube-proxy, node-exporter, metrics-server)

Cluster (kube-apiserver, kube-state-metrics, kube-controller-manager, kube-scheduler)

Pod (kubelet, metrics-server)

Container (kubelet)

---

## Node metrics

<i class="fa-duotone fa-solid fa-server fa-4x"></i> <!-- .element: style="float: right;" -->

- **CPU usage**: Current utilization, requests, and limits
- **Memory usage**: Current utilization, requests, and limits
- **Disk usage**: Capacity, usage, and I/O statistics
- **Network**: Latency, bandwidth, and error rates
- **Node health**: Node conditions, such as ready, disk pressure, memory pressure

---

## Pod metrics

<i class="fa-duotone fa-solid fa-container-storage fa-4x"></i> <!-- .element: style="float: right;" -->

- **CPU usage**: Current utilization, requests, and limits
- **Memory usage**: Current utilization, requests, and limits
- **Network**: Latency, bandwidth, and error rates for pod communication
- **Pod health**: Status of each pod, restart counts, and lifecycle events

---

## Cluster metrics

<i class="fa-duotone fa-solid fa-network-wired fa-4x"></i> <!-- .element: style="float: right;" -->

- Object specific metrics in Kubernetes
- For example:
  - CronJob status
  - Deployment status,
  - Number of ready replicas
  - etc.

---

## Collecting metrics

<i class="fa-duotone fa-solid fa-cart-shopping fa-4x"></i> <!-- .element: style="float: right;" -->

Metrics exporters

Scraping (pull based)

Format

```plaintext
# HELP http_requests_total The total number of HTTP requests.
# TYPE http_requests_total counter
http_requests_total{method="post",code="200"} 1027
http_requests_total{method="post",code="400"} 3
http_requests_total{method="get",code="200"} 1337
# TYPE process_cpu_seconds counter
# UNIT process_cpu_seconds seconds
# HELP process_cpu_seconds Total user and system CPU time spent in seconds.
process_cpu_seconds_total 4.20072246e+06
# EOF
```

Prometheus

Prometheus Operator adds declarative configuration

---

## Why Mimir instead of Prometheus

XXX shortcomings of Prometheus

XXX advantages of Mimir

XXX Mimir in addition to Prometheus

---

## Collecting logs and traces

<i class="fa-duotone fa-solid fa-person-dolly fa-4x"></i> <!-- .element: style="float: right;" -->

Push based

Agents

Accessible endpoints

---

## Firewall considerations

<i class="fa-duotone fa-solid fa-block-brick-fire fa-4x"></i> <!-- .element: style="float: right;" -->

XXX pull

XXX push

---

## Pod logs

Pods produce output on `stdout` and `stderr`

Kubernetes collects the output and stores it in a log file on the node

Logs are automatically rotated

Pod logs are located on the host in `/var/log/pods` (stdout/stderr of containers)

```plaintext
/var/log/pods/kube-system_cilium-<uuid>
.
├── apply-sysctl-overwrites
│   └── 0.log
├── cilium-agent
│   ├── 0.log
│   └── 0.log.20240626-164332
├── clean-cilium-state
│   └── 0.log
├── config
│   └── 0.log
├── install-cni-binaries
│   └── 0.log
├── mount-bpf-fs
│   └── 0.log
└── mount-cgroup
    └── 0.log
```

---

## Traces

Complex distributed systems have many components

**Tracing** is a method to track requests as they flow

It helps to identify, e.g. :
- Slow requests
- Bottlenecks
- Errors
- Performance issues

---

## What is a trace?

A **trace** is single unit of work in a distributed system

A **span** is a single operation within a trace

![](slides/09-monitoring/traces.drawio.svg) <!-- .element: style="width: 90%;" -->

All spans of a trace have the same context, e.g. a unique ID

The context is passed between spans

---

## Traces: Open Telemetry

![](slides/09-monitoring/otel.svg) <!-- .element: style="float: right; width: 10%;" -->

[Open Telemetry](https://opentelemetry.io/) provides observability to your applications

It includes APIs, libraries, agents, and instrumentation

It provides a single set of APIs and libraries to capture distributed traces and metrics from your applications

It is vendor-neutral and supports multiple backends like Jaeger, Tempo, etc.

---

## Tools

<i class="fa-duotone fa-solid fa-screwdriver-wrench fa-4x"></i> <!-- .element: style="float: right;" -->

OpenTelemetry Collector (OtelCol) ![](180_observability/media/opentelemetry-icon-color.svg) <!-- .element: style="width: 1em;" -->

Grafana Alloy - an OTel distribution ![](180_observability/media/alloy.svg) <!-- .element: style="width: 1em;" -->

Grafana Agent (EOL)

Grafana promtail for Loki (deprecated)

---

## Chaining collection

<i class="fa-duotone fa-solid fa-link fa-4x"></i> <!-- .element: style="float: right;" -->

AWS CloudWatch Logs

Azure Monitor Logs

OtelCol/Alloy in between

---

## Application level data

<i class="fa-duotone fa-solid fa-browser fa-4x"></i> <!-- .element: style="float: right;" -->

XXX metrics exporter

XXX log shipping

XXX auto instrumentation
