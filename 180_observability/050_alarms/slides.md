## Alarms

Channels

Rules

Thresholds

Baselines

---

## Why alerting?

**Alerting** is a method to notify you when something goes wrong

The goal is to **reduce downtime** and **improve reliability**

**Identify issues** before they become critical

**Reduce the time to resolution**

proactive > reactive

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

---

## Prometheus Alerting

![](slides/09-monitoring/alerting.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

Multiple deployment options

1. Grafana + Alertmanager

1. Grafana only

1. Alertmanager only

Options 1 and 3 allow alerting rules to be managed through custom resources

Option 2 uses the Grafana UI for managing alerting rules