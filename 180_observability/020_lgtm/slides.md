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
# HELP cpu_usage CPU-Auslastung in Prozent
# TYPE cpu_usage gauge
cpu_usage{node="worker"} 23.7
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

## Tempo

<i class="fa-duotone fa-solid fa-route fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/tempo.svg) <!-- .element: style="float: right; width: 5em;" -->

Distributed tracing backend

Receives traces via OTLP (OpenTelemetry)

Stores traces in cheap object storage (S3, GCS, Azure Blob)

Queries with TraceQL

Correlates traces with logs and metrics

---

## Exercises

![](180_observability/020_lgtm/env.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

### Workshop environment

Dedicated virtual machine

Pre-installed Visual Studio Code

Pre-installed Kubernetes cluster

Pre-installed CLI tools

### Now go to the exercises

[Grafana LGTM](/hands-on/2026-11-19/020_lgtm/exercises/)
