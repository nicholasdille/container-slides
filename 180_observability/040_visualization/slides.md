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

## Dashboards

Represents tailored view on a topic

Collection of panels

Each panel displays one aspect

Data is pulled from various data sources

Configurable time range

Custom filters

---

## Exercises for Grafana

[Visualization exercises](/hands-on/2026-11-19/040_visualization/exercises_grafana/)

---

## PromQL

Grafana → `Explore` → Prometheus data source

Select `Code` instead of `Build`

Every query on the following slides can be tested

---

## Remember

### Format

`<name>{<key>=<value>,...} value`

### Counter

Only increases, resets to `0` on restart

### Gauge

Goes up and down, current state

### Histogram

Bucketed observations, latency distributions

---

## Selectors: label matchers

### Examples

```promql
container_memory_working_set_bytes{namespace="shop"}
container_memory_working_set_bytes{namespace=~"shop|payments", container!=""}
```

| Operator | Description     |
|----------|-----------------|
| `=`      | exact match     |
| `!=`     | not equal       |
| `=~`     | regex match     |
| `!~`     | regex not match |

---

## The empty container label

Exclude empty containers:

```promql
container_memory_working_set_bytes{container!=""}
```

### Cause

Pods are created by a hidden container running `pause`

---

## Counters

Values are monotonicly increasing

Rate of change over time is of interest

```promql
rate(container_cpu_usage_seconds_total{container!=""}[5m])
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

Wraps the inner expression

```promql
sum by (namespace) (container_memory_working_set_bytes{container!=""})
```

`sum`, `avg`, `min`, `max`, `count`, `stddev`

`without` instead of `by` drops only the given labels

---

## Range functions for gauges

Sliding window functions

No aggregation

```promql
max_over_time(container_memory_working_set_bytes{container=""}[24h])
```

`avg_over_time`, `min_over_time`, `last_over_time`

Long windows are expensive

---

## Vector matching (Join)

Require identical label sets

`on (...)` match on selected labels

`group_left` many to one (attach extra labels)

```promql
x * on (instance) group_left(nodename) node_uname_info
```

Mismatches silently produce empty results

---

## Exercises for PromQL

[Visualization](/hands-on/2026-11-19/040_visualization/exercises_metrics/)

---

## LogQL

Grafana → `Explore` → Loki data source

Start with a single component and look at the raw lines

Every query in this section works as a live demo

---

## Data model: streams and lines

The selector picks log streams, not single lines

Stream = unique label set, labels are indexed and cheap

Line content is not indexed, every filter reads lines

Keep labels few and low cardinality

Everything else happens per line in the pipeline

---

## Stream selectors

All logs of one component:

```plaintext
{service_name="kube-apiserver"}
```

Same matcher operators as PromQL: `=`, `!=`, `=~`, `!~`

```plaintext
{namespace="kube-system", pod=~"coredns-.*"}
```

Start narrow: component, namespace, node

---

## Line filters

Contains / does not contain:

```plaintext
{service_name="kube-apiserver"} |= `Unauthorized`
{service_name="kube-apiserver"} != `/healthz`
```

Regex, case insensitive with `(?i)`:

```plaintext
{namespace="kube-system"} |~ `(?i)error|failed`
```

Chain filters, cheapest first:

```plaintext
{service_name="kube-apiserver"} |= `request` |= `failed` |~ `40[134]`
```

---

## Parsers: json

Parse all fields, then filter:

```plaintext
{service_name="kube-apiserver"} | json | OriginStatus="401"
```

Parse only needed fields, much faster:

```plaintext
{service_name="kube-apiserver"} | json OriginStatus, Verb | OriginStatus="401", Verb!="GET"
```

---

## Parsers: plain text formats

`logfmt` for `key=value` lines:

```plaintext
{service_name="kube-scheduler"} | logfmt | err!=""
```

`pattern` with a literal template:

```plaintext
{service_name="kubelet"} | pattern `<timestamp> <level> <msg>`
```

`regexp` with named capture groups as fallback:

```plaintext
{service_name="etcd"} | regexp `took too long (?P<duration>\S+)`
```

---

## Metrics from logs

Wrap a pipeline in a range function

Lines per second:

```plaintext
rate({service_name="kube-apiserver"} |= `Unauthorized` [5m])
```

Matches per minute:

```plaintext
count_over_time({service_name="coredns"} |~ `NXDOMAIN` [10m])
```

Log volume per stream:

```plaintext
bytes_over_time({namespace="kube-system"} [1h])
```

---

## Aggregation

This is what dashboard panels and alert rules use

Top 5 services by lines matched:

```plaintext
topk(5, sum by (service_name) (count_over_time({namespace="kube-system"} [1h])))
```

Post requests per pod:

```plaintext
sum by (pod) (rate({app="traefik"} | json | RequestMethod="POST" [5m]))
```

---

## Exercises for LogQL

[Visualization](/hands-on/2026-11-19/040_visualization/exercises_logs/)

---

## Exercises for TraceQL

[Visualization](/hands-on/2026-11-19/040_visualization/exercises_traces/)

---

## AI-created dashboards

AI is capable of automatically generating dashboards

Grafana offers an MCP server

### Demo

1. Create a service account in Grafana
1. Create a token for the service account
1. Configure OpenCode with the token in `~/.config/opencode/opencode.jsonc`
1. Start OpenCode

### Examples

```plaintext
Create a dashboard with panels for CPU usage and memory usage per pod. The namespace should be selectable through a variable.
```
