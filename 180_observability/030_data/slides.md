<i class="fa-duotone fa-solid fa-vacuum fa-4x"></i> <!-- .element: style="float: right;" -->

# Data Collection

---

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

## Traditional data collection

XXX agents

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

**CPU usage**: Current utilization, requests, and limits

**Memory usage**: Current utilization, requests, and limits

**Disk usage**: Capacity, usage, and I/O statistics

**Network**: Latency, bandwidth, and error rates

**Node health**: Node conditions, such as ready, disk pressure, memory pressure

---

## Pod metrics

<i class="fa-duotone fa-solid fa-container-storage fa-4x"></i> <!-- .element: style="float: right;" -->

**CPU usage**: Current utilization, requests, and limits

**Memory usage**: Current utilization, requests, and limits

**Network**: Latency, bandwidth, and error rates for pod communication

**Pod health**: Status of each pod, restart counts, and lifecycle events

---

## Cluster metrics

<i class="fa-duotone fa-solid fa-network-wired fa-4x"></i> <!-- .element: style="float: right;" -->

Object specific metrics in Kubernetes

CronJob status

Deployment status,

Number of ready replicas

etc.

---

## Collecting metrics

<i class="fa-duotone fa-solid fa-cart-shopping fa-4x"></i> <!-- .element: style="float: right;" -->

Metrics exporters

Scraping (pull based)

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

XXX push based

XXX agents

XXX accessible endpoints

---

## Firewall considerations

<i class="fa-duotone fa-solid fa-block-brick-fire fa-4x"></i> <!-- .element: style="float: right;" -->

XXX pull

XXX push

---

## Tools

<i class="fa-duotone fa-solid fa-screwdriver-wrench fa-4x"></i> <!-- .element: style="float: right;" -->

### OpenTelemetry Collector (OtelCol) ![](180_observability/media/opentelemetry-icon-color.svg) <!-- .element: style="width: 1em;" -->

Vendor neutral standard

Support for all signals

Modular but complex configuration

### Grafana Alloy - an OTel distribution ![](180_observability/media/alloy.svg) <!-- .element: style="width: 1em;" -->

Custom distribution of OtelCol

Supercedes Grafana Agent (EOL since 2025-11-01) and promtail (deprecated)

Collect, transform and forward data

### k8s-monitoring

Uber helm chart based on Alloy to collect EVERYTHING

---

## Chaining collection

<i class="fa-duotone fa-solid fa-link fa-4x"></i> <!-- .element: style="float: right;" -->

XXX AWS CloudWatch

XXX Azure Monitor

XXX OtelCol/Alloy in between

---

## Application level data

<i class="fa-duotone fa-solid fa-browser fa-4x"></i> <!-- .element: style="float: right;" -->

XXX metrics exporter (integrated, sidecar)

XXX log shipping

XXX auto instrumentation

---

## Data transformation

XXX
