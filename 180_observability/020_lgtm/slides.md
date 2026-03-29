<i class="fa-duotone fa-solid fa-layer-group fa-4x"></i> <!-- .element: style="float: right;" -->

# Grafana LGTM Stack

---

## LGTM Stack

Grafana Labs

Metrics with Mimir (instead of Prometheus)

Logs with Loki - Horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus

Traces with Tempo

(Profiling with Beyla)

Visualization with Grafana

LGTM - Looks Good To Me ;-)

---

## Grafana

![](180_observability/media/grafana.svg) <!-- .element: style="float: right; width: 5em;" -->

XXX

---

## Mimir

<i class="fa-duotone fa-solid fa-chart-fft fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/mimir.svg) <!-- .element: style="float: right; width: 5em;" -->

XXX equivalent to Prometheus

XXX microservices for scalability

XXX long-term storage

XXX no scraping - often chained with Prometheus - alloy will be introduced later

---

## Data format

XXX `<name>{<key>=<value>,...} value`

### Counter

```plaintext
# HELP http_requests_total Anzahl der HTTP Requests
# TYPE http_requests_total counter
http_requests_total{method="post",code="200"} 1027
http_requests_total{method="post",code="400"} 3
```

---

## Data format

XXX `<name>{<key>=<value>,...} value`

### Gauge

```plaintext
# HELP cpu_usage CPU-Auslastung in Prozent
# TYPE cpu_usage gauge
cpu_usage{node="capricorn"} 23.7
```

---

## Data format

XXX `<name>{<key>=<value>,...} value`

### Histogram

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
```

---

## Data format

XXX <name>{<key>=<value>,...} value

### Summary

XXX ???

---

## Query Language

XXX PromQL

---

## Loki

<i class="fa-duotone fa-solid fa-file-lines fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/loki.svg) <!-- .element: style="float: right; width: 4em;" -->

XXX

---

## Query Language

XXX LogQL

---

## Tempo

<i class="fa-duotone fa-solid fa-route fa-4x"></i> <!-- .element: style="float: right;" -->

![](180_observability/media/tempo.svg) <!-- .element: style="float: right; width: 5em;" -->

XXX

---

## Query Language

XXX TraceQL
