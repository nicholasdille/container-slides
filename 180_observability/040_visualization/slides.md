<i class="fa-duotone fa-solid fa-chart-line fa-4x"></i> <!-- .element: style="float: right;" -->

# Visualization

---

## Why is data visualization crucial?

**Simplifies complex data**: Easy-to-understand visuals

**Faster insights**: Quick identification of patterns and trends

**Improves monitoring**: Spot issues and anomalies at a glance

**Enhanced communication**: Clear insights for stakeholders

**Better analysis**: Detailed understanding of metrics

---

## Benefits of data visualization

**Pattern recognition**: Identify trends, outliers, and correlations

**Real-time monitoring**: Up-to-date visual insights

**Historical comparison**: Compare current and past data

**Custom dashboards**: Tailor views for focused monitoring

**Interactive exploration**: Drill down for detailed analysis

---

## PromQL

Practical introduction in one hour

Prometheus query language

Read it: dashboards, alerts, `kubectl`-like insight into the cluster

Write it: ad hoc analysis in Grafana Explore

---

## One hour plan

### Theory and live demos (~40 minutes)

Data model → selectors → counters → gauges → aggregation → range functions → pitfalls

### Hands on (~20 minutes)

Exercises in `exercises_metrics.md`

Bring questions from your own clusters

---

## Setup

Grafana → `Explore` → Prometheus data source

Select `Code` instead of `Build`

Every query in this section works as a live demo

XXX insert screenshot of Explore in code mode

---

## Metrics available in a cluster

### kubelet / cAdvisor (per container)

`container_cpu_usage_seconds_total`, `container_memory_working_set_bytes`, `container_network_receive_bytes_total`, `container_fs_writes_bytes_total`

### kube-state-metrics (per object)

`kube_pod_status_phase`, `kube_pod_container_status_restarts_total`, `kube_pod_container_resource_requests`, `kube_pod_container_resource_limits`, `kube_deployment_status_replicas_available`

---

## Data model: metric types

### Counter

Only increases, resets to `0` on restart

### Gauge

Goes up and down, current state

### Histogram

Bucketed observations, latency distributions

Type decides which functions make sense

---

## Selectors: label matchers

```promql
container_memory_working_set_bytes{namespace="shop"}
```

`=` exact match, `!=` not equal

`=~` regex match, `!~` regex not match

```promql
container_memory_working_set_bytes{namespace=~"shop|payments", pod!=""}
```

---

## Two important filter tricks

Exclude empty containers (pod level entries, duplicates numbers):

```promql
{container!=""}
```

---

## The counter problem

Counter resets to `0` on every restart

Naive difference produces huge negative spikes

```promql
rate(container_cpu_usage_seconds_total{container!=""}[5m])
```

`rate()` handles resets, extrapolates to per second

`irate()` uses only the last two samples, spiky

---

## Aggregation operators

`sum`, `avg`, `min`, `max`, `count`, `stddev`

```promql
sum by (namespace) (container_memory_working_set_bytes{container!=""})
```

`without` instead of `by` drops only the given labels

Aggregation wraps the inner expression

---

## Range functions for gauges

```promql
max_over_time(container_memory_working_set_bytes{container=""}[24h])
```

`avg_over_time`, `min_over_time`, `last_over_time`

Use case: peak memory of the last day vs today

Long windows are expensive

---

## Vector matching

Binary operators need identical label sets

`on (...)` match on selected labels

`group_left` many to one (attach extra labels)

```promql
x * on (instance) group_left(nodename) node_uname_info
```

Mismatches silently produce empty results

---

## LogsQL

All log lines for the label filter:

```plaintext
{namespace=kube-system}
```

Filter for string `dns`:

```plaintext
{namespace=kube-system} |= `dns`
```

Exclude lines with string `dns`:

```plaintext
{namespace=kube-system} != `dns`
```

XXX json

XXX pattern

---

## TraceQL

XXX

---

## Dashboards

XXX dashboard represents specialized overview

Collection of panels

Each panel displays one aspect

XXX data sources

XXX time range

XXX filters

---

## AI-created dashboards

XXX
