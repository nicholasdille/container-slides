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

All time series for a metric:

```text
http_requests_total
```

Data for the given label filter:

```text
http_requests_total{job="apiserver", handler="/api/comments"}
```

Rate of change with a sliding window of 5 minutes:

```text
rate(http_requests_total{job="apiserver", handler="/api/comments"}[5m])
```

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
