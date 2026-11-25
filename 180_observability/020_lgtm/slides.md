<i class="fa-duotone fa-solid fa-layer-group fa-4x"></i> <!-- .element: style="float: right;" -->

# Grafana LGTM Stack

---

## LGTM Stack

Grafana Labs

Horizontally scalable architecture

- <img src="180_observability/media/grafana.svg" style="height: 2em;" /><br/>**Grafana** for visualization<br/>Dashboards<br/>Alerting
- <img src="180_observability/media/mimir.svg" style="height: 2em;" /><br/>**Mimir** for metrics<br/>Long-term storage<br/>High performance query engine
- <img src="180_observability/media/loki.svg" style="height: 2em;" /><br/>**Loki** for logs<br/>Multi-tenancy<br/>Inspired by Prometheus
- <img src="180_observability/media/tempo.svg" style="height: 2em;" /><br/>**Tempo** for traces<br/>High-volume tracing at low cost<br/>Based on OpenTelemetry

<!-- .element: class="flex-columns" style="text-align: center;" -->

(Profiling with Beyla ![](180_observability/media/beyla.svg) <!-- .element: style="height: 0.8em;" -->)

---

## Grafana

![](180_observability/media/grafana.svg) <!-- .element: style="float: right; width: 5em;" -->

Open source visualization and observability platform

Connects to many data sources

- Time series (Mimir, Prometheus, InfluxDB)
- Logs (Loki, Elasticsearch)
- Traces (Tempo, Jaeger)
- SQL databases and cloud services

Dashboards with a large plugin ecosystem

Alerting engine with notification channels

Explore view for ad-hoc queries

Dashboards can be provisioned as code

---

## Mimir

<i class="fa-duotone fa-solid fa-chart-fft fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/mimir.svg) <!-- .element: style="float: right; width: 5em;" -->

Replacement for Prometheus

Microservices for scalability

Long-term storage

High performance query engine fully compatible with PromQL

### Offers no scraping

Often chained with Prometheus

Alternatives will be introduced later ;-)

---

## Why Mimir instead of Prometheus

### Prometheus does not scale

- Monolithic process
- Only scales vertically
- Memory usage increases with stored data
- WAL replay makes startup slow

### Mimir scales well

- Microservices
- Scales horizontally as well
- Designed for long-term storage
- Does not scrape on its own

---

![](180_observability/media/mimir.svg) <!-- .element: style="width: 10%; float: right;" -->

## Mimir

Source:  [Grafana Mimir Architecture](https://grafana.com/docs/mimir/latest/get-started/about-grafana-mimir-architecture/about-ingest-storage-architecture/)

![](180_observability/060_architecture/mimir.drawio.svg) <!-- .element: style="width: 45%; float: right;" -->

### Deployment modes

Monolithic, scale monolithic, microservices [](https://grafana.com/docs/mimir/latest/references/architecture/deployment-modes/)

Helm only supports microservices mode

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/mimir/latest/manage/run-production-environment/planning-capacity/)

---

## Data format

`<name>{<key>=<value>,...} value`

### Counter

Represents a value that only increases and resets to zero

```plaintext
# HELP http_requests_total Anzahl der HTTP Requests
# TYPE http_requests_total counter
http_requests_total{method="post",code="200"} 1027
http_requests_total{method="post",code="400"} 3
# EOF
```

---

## Data format

`<name>{<key>=<value>,...} value`

### Gauge

Represents a value that can go up and down

```plaintext
# HELP container_memory_working_set_bytes Memory usage in percent
# TYPE container_memory_working_set_bytes gauge
container_memory_working_set_bytes{node="worker"} 23.7
# EOF
```

---

## Data format

`<name>{<key>=<value>,...} value`

### Histogram

Represents a value that samples observations

```plaintext
# HELP http_request_duration_seconds Dauer der HTTP Requests
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{le="0.1"} 24054
http_request_duration_seconds_bucket{le="0.2"} 33444
http_request_duration_seconds_bucket{le="0.5"} 100392
http_request_duration_seconds_bucket{le="1"} 129389
http_request_duration_seconds_bucket{le="+Inf"} 144320
http_request_duration_seconds_sum 53423
http_request_duration_seconds_count 144320
# EOF
```

---

## Loki

<i class="fa-duotone fa-solid fa-file-lines fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/loki.svg) <!-- .element: style="float: right; width: 4em;" -->

Log aggregation system

Indexes only labels, not log contents

Stores compressed chunks in cheap object storage

### Cost-efficient

Queries with LogQL, modeled on PromQL

Collection via Grafana Alloy (successor of Promtail)

---

![](180_observability/media/loki.svg) <!-- .element: style="width: 7%; float: right;" -->

## Loki

Source:  [Grafana Loki Architecture](https://grafana.com/docs/loki/latest/get-started/architecture/)

![](180_observability/060_architecture/loki.drawio.svg) <!-- .element: style="width: 40%; float: right;" -->

### Deployment modes

Single binary, simple scalable deployment, microservices [](https://grafana.com/docs/loki/latest/get-started/components/) [](https://grafana.com/docs/loki/latest/get-started/deployment-modes/)

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/loki/latest/setup/size/)

---

## Tempo

<i class="fa-duotone fa-solid fa-route fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/tempo.svg) <!-- .element: style="float: right; width: 5em;" -->

Distributed tracing backend

Receives traces via OTLP (OpenTelemetry)

Stores traces in cheap object storage (S3, GCS, Azure Blob)

Queries with TraceQL

Correlates traces with logs and metrics

---

![](180_observability/media/tempo.svg) <!-- .element: style="width: 7%; float: right;" -->

## Tempo

Source: [Tempo architecture](https://grafana.com/docs/tempo/latest/introduction/architecture/)

![](180_observability/060_architecture/tempo.drawio.svg) <!-- .element: style="width: 40%; float: right;" -->

### Deployment modes

Monolithic, microservices [](https://grafana.com/docs/tempo/latest/reference-tempo-architecture/deployment-modes/)

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/plan/size/)

---

## Hands-On

![](180_observability/020_lgtm/env.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

### Workshop environment

Dedicated virtual machine

Pre-installed Visual Studio Code

Pre-installed Kubernetes cluster

Pre-installed CLI tools

### Now go to the exercises

Deploy the [Grafana LGTM](/hands-on/2026-11-19/020_lgtm/exercises/) stack
