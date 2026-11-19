<i class="fa-duotone fa-solid fa-vacuum fa-4x"></i> <!-- .element: style="float: right;" -->

# Data Collection

---

## Data Collection

<i class="fa-duotone fa-solid fa-vacuum fa-4x"></i> <!-- .element: style="float: right;" -->

Centralized storage
- Independent of system availability
- Correlation
- Harder to temper with

---

## Data Collection

<i class="fa-duotone fa-solid fa-vacuum fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/030_data/collection.drawio.svg) <!-- .element: style="width: 50%;" -->

---

## Traditional data collection

> You get an agent. You get an agent. Everyone gets an agent!
> 
> — Oprah Winfrey

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

## Collecting logs and traces

<i class="fa-duotone fa-solid fa-person-dolly fa-4x"></i> <!-- .element: style="float: right;" -->

Both are collected push-based

Collection done by agents or instrumentation

Endpoints for Loki and Tempo must be accessible

---

## Firewall considerations

<i class="fa-duotone fa-solid fa-block-brick-fire fa-4x"></i> <!-- .element: style="float: right;" -->

Pull-based collection is usually blocked by firewalls

Push-based collection sends the data to a public endpoint

![](180_observability/030_data/firewall.drawio.svg) <!-- .element: style="width: 50%;" -->

---

## Tools

<i class="fa-duotone fa-solid fa-screwdriver-wrench fa-4x"></i> <!-- .element: style="float: right;" -->

### OpenTelemetry Collector (OtelCol) ![](180_observability/media/opentelemetry-icon-color.svg) <!-- .element: style="width: 1em;" -->

Vendor-neutral standard

Support for all signals

Modular but complex configuration

### Grafana Alloy ![](180_observability/media/alloy.svg) <!-- .element: style="width: 1em;" -->

Custom distribution of OtelCol

Collect, transform and forward data

Supercedes Grafana Agent and promtail

---

## Chaining collection

<i class="fa-duotone fa-solid fa-link fa-4x"></i> <!-- .element: style="float: right;" -->

Collect data using the native services offered by providers:
- AWS CloudWatch
- Azure Monitor

Use OtelCol/Alloy to centralize data from multiple sources

![](180_observability/030_data/provider.drawio.svg) <!-- .element: style="width: 50%;" -->

---

## Application level data

<i class="fa-duotone fa-solid fa-browser fa-4x"></i> <!-- .element: style="float: right;" -->

### Utilize existing exporter

- Integrated endpoints
- Sidecars (possibly community projects or paid extensions)
- Maybe need to convert data into OpenMetrics format

### Log shipping is mostly solved

- Container logs are scraped automatically
- Log files can be scraped as well

### Distributed tracing

- Instrumentation through SDKs for many languages
- Auto-Instrumentation

---

## Application level data

<i class="fa-duotone fa-solid fa-browser fa-4x"></i> <!-- .element: style="float: right;" -->

### `ServiceMonitor`

Declarative configuration for scraping

Publishes scrape endpoints through Kubernetes services

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: frontend-podinfo
spec:
  # in which namespace to look for the service
  namespaceSelector:
    matchNames:
    - default
  # which services to select for scraping
  selector:
    matchLabels:
      app.kubernetes.io/name: frontend-podinfo
  # which endpoints to scrape for the selected services
  endpoints:
  - interval: 15s
    path: /metrics
    port: http
```

<!-- .element: style="height: 22em; width: 30em; float: right;" -->

![](180_observability/030_data/servicemonitor.drawio.svg) <!-- .element: style="width: 50%;" -->

---

## Data transformation

```yaml
# OpenTelemetry Collector
# Receiver -> Processor -> Exporter
# Declarative

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp/jaeger]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [otlp/prometheus]
```

<!-- .element: style="width: 30em; height: 22em; float: left;" -->

```
# Grafana Alloy
# Similar in concept but different format
# Functional

discovery.kubernetes "pods" {
  role = "pod"
}

prometheus.scrape "app_metrics" {
  targets    = discovery.kubernetes.pods.targets
  forward_to = [prometheus.remote_write.production.receiver]
}

prometheus.remote_write "production" {
  endpoint {
    url = "https://prometheus.example.com/api/v1/write"
  }
}   
```

<!-- .element: style="width: 38em; height: 22em; float: right;" -->

---

## Exercises

[Data Collection](/hands-on/2026-11-19/030_data/exercises/)
