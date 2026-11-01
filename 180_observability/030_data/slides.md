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

Cluster (kube-apiserver, kube-state-metrics, kube-controller-manager, kube-scheduler)

Host OS (Linux)

Node

Pod/container

---

## Cluster metrics

<i class="fa-duotone fa-solid fa-network-wired fa-4x"></i> <!-- .element: style="float: right;" -->

Object-specific metrics in Kubernetes

CronJob status

Deployment status,

Number of ready replicas

etc.

---

## Node metrics

<i class="fa-duotone fa-solid fa-server fa-4x"></i> <!-- .element: style="float: right;" -->

**CPU usage**: Current utilization, requests, and limits

**Memory usage**: Current utilization, requests, and limits

**Disk usage**: Capacity, usage, and I/O statistics

**Network**: Latency, bandwidth, and error rates

**Node health**: Node conditions, such as ready, disk pressure, memory pressure

Sources: kubelet, kube-proxy, node-exporter, metrics-server

---

## Pod/container metrics

<i class="fa-duotone fa-solid fa-container-storage fa-4x"></i> <!-- .element: style="float: right;" -->

**CPU usage**: Current utilization, requests, and limits

**Memory usage**: Current utilization, requests, and limits

**Network**: Latency, bandwidth, and error rates for pod communication

**Pod health**: Status of each pod, restart counts, and lifecycle events

Source: kubelet, metrics-server

---

## Collecting metrics

<i class="fa-duotone fa-solid fa-cart-shopping fa-4x"></i> <!-- .element: style="float: right;" -->

Metrics exporters

Scraping (pull based)

Prometheus

Prometheus Operator adds declarative configuration

---

## Why Mimir instead of Prometheus

### Prometheus does not scale

- Monolithic process
- Memory usage increases with stored data
- WAL replay makes startup slow

### Mimir scales well

- Microservices
- Scales horizontally and vertically
- Designed for long-term storage
- Does not scrape on its own

---

## Collecting logs and traces

<i class="fa-duotone fa-solid fa-person-dolly fa-4x"></i> <!-- .element: style="float: right;" -->

Both are collected push-based

Collection done by agents or instrumentation

Endpoints for Loki and Tempo must be accessible

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

---

## Chaining collection

<i class="fa-duotone fa-solid fa-link fa-4x"></i> <!-- .element: style="float: right;" -->

XXX AWS CloudWatch

XXX Azure Monitor

XXX OtelCol/Alloy in between

---

## Application level data

<i class="fa-duotone fa-solid fa-browser fa-4x"></i> <!-- .element: style="float: right;" -->

### Utilize existing exporter

- Integrated endpoints
- Sidecars (possibly community projects or paid extensions)
- Maybe need to convert data into OpenMetrics format

### Log shipping is mostly solved

- Log files can be scraped
- Container logs can be scraped

### Tracing

- Instrumentation through SDKs for many languages
- Auto-Instrumentation

---

## Data transformation

XXX otel pipelines

XXX alloy pipelines
