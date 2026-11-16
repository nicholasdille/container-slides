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

### prometheus-operator

Popular and also supports alerting (via CRDs and AlertManager)

### Grafana

Has a built-in alerting engine

### AlertManager

Standalone component that can be used with Prometheus

### Cloud Monitoring

AWS CloudWatch, Google Cloud Monitoring, etc.

---

## Prometheus Alerting

Multiple deployment options

1. Grafana + Alertmanager

1. Grafana only

1. Alertmanager only

Options 1 and 3 allow alerting rules to be managed through custom resources

Option 2 uses the Grafana UI for managing alerting rules

Scope of workshop: Alertmanager only

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

Routing Tree: Rules for receivers

Receivers: Channels (Slack, Mail, PagerDuty etc.)

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

---

## Anatomy of an alert rule

`expr`: PromQL query, any result above `0` triggers the alert

`for`: Condition must hold this long, avoids flapping

`labels`: Identity of the alert, used for grouping and routing

`annotations`: Human readable text, templated with `{{ $labels.pod }}` and `{{ $value }}`

Labels for machines, annotations for humans

---

## Routing

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

Supported receivers include: Email, Slack, Teams, Discord, Jira, WebHook

---

## Routing & Deduplication

### Matching

Alerts enter at the root route and walk down child routes, matched by label matchers

First matching child route wins, `continue: true` evaluates further routes

Allows notifying multiple receivers, e.g. mail for warnings, pager for criticals

### Grouping

`group_by: [alertname, team]`: alerts with identical label values are bundled into a single notification

Prevents notification storms during large outages

### Timing

`group_wait`: wait before the first notification of a new group, default 30s

`group_interval`: minimum time between notifications of a group that received new alerts, default 5m

`repeat_interval`: re-notify an unchanged group, default 4h

### Deduplication

Alerts with an identical set of labels are treated as a single alert

Also filters duplicates from redundant sources, e.g. a high availability pair of Alertmanagers

---

## Silences & Inhibition

### Silences

Temporarily mute alerts whose labels match given matchers

Created in the Alertmanager UI or via `amtool`, with creator, comment and duration

Alerts still show as silenced, no notification is sent

### Inhibition

Rules in the Alertmanager config: when a source alert fires, matching target alerts are muted

Defined by `source_matchers`, `target_matchers` and `equal` labels

Example: inhibit warnings when the same service is already critical

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
