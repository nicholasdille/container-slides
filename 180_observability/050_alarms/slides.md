<i class="fa-duotone fa-solid fa-bell-ring fa-4x"></i> <!-- .element: style="float: right;" -->

# Alarms

---

## Why alerting?

**Alerting** is a method to notify you when something goes wrong

The goal is to **reduce downtime** and **improve reliability**

**Identify issues** before they become critical

**Reduce the time to resolution**

**proactive** > **reactive**

---

## Alerting tools

Among many others...

### Grafana

Has a built-in alerting engine

### AlertManager

Standalone component that can be used with Prometheus

### Cloud Monitoring

AWS CloudWatch, Google Cloud Monitoring, etc.

### prometheus-operator

Popular and also supports alerting (via CRDs and AlertManager)

---

## Prometheus Alerting

Multiple deployment options

1. Grafana + Alertmanager

1. Grafana only

1. Alertmanager only

Options 1 and 3 allow alerting rules to be managed through custom resources

Option 2 uses the Grafana UI for managing alerting rules

### Scope of workshop: Alertmanager only

---

## Grafana vs. Alertmanager

| Aspect        | Grafana Alerts   | Alertmanager        |
|---------------|------------------|---------------------|
| Data sources  | Many             | Prometheus only     |
| Setup         | Very fast        | Prometheus + Config |
| Routing       | Easy / Medium    | Very powerful       |
| Deduplication | Basic            | Mature              |

---

## Alert Manager

Part of Prometheus ecosystem

Receives firing alerts from Prometheus, Grafana or the Mimir ruler

Does not evaluate rules itself

Purpose: Grouping, Deduplication, Routing, Silencing, Inhibition

### Concepts

Labels: Context for alerts (service, component, team)

Grouping: Bundle similar alerts into a single message

Receivers: Channels (Email, messengers, webhook etc.)

Routing Tree: Rules for receivers

---

## Alert pipeline

Alerting is split into two jobs

### Rule evaluation

Runs a query on a schedule and decides when something is wrong

Done by Prometheus, Grafana or the Mimir ruler

### Notification

Alertmanager receives firing alerts and decides who gets notified

Grouping → deduplication → silencing → routing → delivery

---

## Declarative alerts: `PrometheusRule`

Alerts are Kubernetes resources, stored and versioned in git

Prometheus discovers them through label selectors

```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: podinfo-alerts
spec:
  groups:
  - name: podinfo
    rules:
    - alert: PodRestartingTooOften
      expr: increase(kube_pod_container_status_restarts_total[30m]) > 3
      for: 5m
      labels:
        severity: warning
        team: shop
      annotations:
        summary: Pod {{ $labels.pod }} restarts too often
        description: More than 3 restarts in the last 30 minutes
```

<!-- .element: style="height: 21em;" -->

---

## Anatomy of an alert rule

`expr`: PromQL query, any result above `0` triggers the alert

`for`: Condition must hold this long, avoids flapping

`labels`: Identity of the alert, used for grouping and routing

`annotations`: Human-readable, templated text

### Labels for machines, annotations for humans

---

## Routing

Supported receivers include: Email, Slack, Teams, Discord, Jira, WebHook

Routing defines how alerts are sent to receivers based on their labels and other criteria:

```yaml
route:
  group_by: [alertname, team]
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h
  routes:
  - matchers:
    - team="shop"
    receiver: shop-mail
receivers:
- name: shop-mail
  email_configs:
  - to: shop@example.com
```

<!-- .element: style="height: 16em;" -->

---

## Routing

### Matching

Matched by labels from root route to child routes

Allows notifying multiple receivers

---

## Deduplication

### Grouping

Group by labels

Prevents notification storms during large outages

### Timing

Wait before the first notification (`group_wait`)

Minimum time between notifications of a group (`group_interval`)

Re-notify an unchanged group (`repeat_interval`)

### Deduplication

Alerts with an identical set of labels are treated as a single alert

---

## Silences & Inhibition

### Silences

Matched by labels

Temporarily mute alerts whose labels match given matchers

Alerts show as silenced, no notification is sent

### Inhibition

Rules in the Alertmanager config: when a source alert fires, matching target alerts are muted

Defined by `source_matchers`, `target_matchers` and `equal` labels

### Use Cases

Maintenance windows: silence alerts during planned changes

Only alert for root cause: inhibit the effects, page the cause

---

## Best Practices

Choose labels wisely

Few and helpful alerts

Establish conventions for formatting alerts

Establish priorities

Make use of snooze and silence

Avoid alerting fatigue

Store alerts in git for versioning and documentation

---

## Exercises

XXX link to exercises
