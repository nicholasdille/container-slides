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

![](slides/09-monitoring/alerting.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

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

Evaluates queries (rules) against Mimir, Loki and Tempo

Purpose: Grouping, Deduplication, Routing, Silencing, Inhibition

### Concepts

Labels: Context for alerts (service, component, team)

Grouping: Bundle similar alerts into a single message

Routing Tree: Rules for receivers

Receivers: Channels (Slack, Mail, PagerDuty etc.)

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
