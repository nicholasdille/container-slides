## Visualization

XXX

---

## Why is data visualization crucial?

- **Simplifies complex data**: Easy-to-understand visuals
- **Faster insights**: Quick identification of patterns and trends
- **Improves monitoring**: Spot issues and anomalies at a glance
- **Enhanced communication**: Clear insights for stakeholders
- **Better analysis**: Detailed understanding of metrics

---

## Benefits of data visualization

- **Pattern recognition**: Identify trends, outliers, and correlations
- **Real-time monitoring**: Up-to-date visual insights
- **Historical comparison**: Compare current and past data
- **Custom dashboards**: Tailor views for focused monitoring
- **Interactive exploration**: Drill down for detailed analysis

---

## Data transformation

XXX

---

## Dashboard

Query languages
- Prometheus Query Language (PromQL)
- Log Query Language (LogQL)
- Trace Query Language (TraceQL)

XXX SQL-based pipelines language?!

---

## Example PromQL Queries

Query structure:
```text
<metric_name>{<label_name>=<label_value>}[<aggregation_interval>]
```

Examples:

```text
# Select all time series for a metric
http_requests_total
```

```text
# Return http_requests_total for given job and handler labels
http_requests_total{job="apiserver", handler="/api/comments"}
```

```text
# 5-minute range of http_requests_total for given job and handler labels
http_requests_total{job="apiserver", handler="/api/comments"}[5m]
```
```text
# Regex
http_requests_total{job=~".*server"}
```