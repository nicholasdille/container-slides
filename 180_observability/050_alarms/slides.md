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

## Scope of this Workshop

Alerting based on prometheus metrics

Prometheus-Operator and AlertManager...

...with custom resources

XXX grafana unified alerting for small to medium deployments

---

## Prometheus Alerting

XXX image

Multiple deployment options

1. Grafana + Alertmanager

1. Grafana only

1. Alertmanager only

Options 1 and 3 allow alerting rules to be managed through custom resources

Option 2 uses the Grafana UI for managing alerting rules

Scope of workshop: Alartmanager only

---

## Grafana vs. Alertmanager

| Aspekt	    | Grafana Alerts   | Alertmanager        |
|---------------|------------------|---------------------|
| Datenquellen	| Viele	           | Nur Prometheus      |
| Einrichtung	| Sehr schnell	   | Prometheus + Config |
| Routing	    | Einfach / Mittel | Sehr mächtig        |
| Deduplication | Grundlegend	   | Ausgereift          |

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

## Routing in Alertmanager

Alertmanager matches alerts by label matchers along a route tree

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

`group_by` bundles similar alerts into a single notification

---

## Declarative routing: `AlertmanagerConfig`

Routing per namespace, also a Kubernetes resource

```yaml
apiVersion: monitoring.coreos.com/v1
kind: AlertmanagerConfig
metadata:
  name: shop
  namespace: shop
spec:
  route:
    matchers:
    - team="shop"
    receiver: shop-mail
  receivers:
  - name: shop-mail
    emailConfigs:
    - to: shop@example.com
```

Requires an Alertmanager managed by prometheus-operator

---

## Routing & Deduplication

XXX matchers

XXX continue

XXX group_by

XXX group_wait / group_interval / repeat_interval

XXX dedup

---

## Silences & Inhibition

XXX silence

XXX inhibition

### Use Cases

Maintenance windows

Only alert for root cause

---

## Best Practices

Choose labels wisely

XXX severity, e.g. warning, critical, page

XXX groups alerts per service

XXX inhibition for root cause

Establish SLO/SLI

Include links in alerts

---

## Best Practices

Few and helpful alerts

Establish conventions for formatting alerts

Establish priorities

Make use of snooze and silence

Avoid alerting fatigue

Store alerts in git for versioning and documentation
