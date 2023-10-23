## Prometheus

![](images/logos/prometheus.svg) <!-- .element: style="float: right; width: 4em;" -->

De facto standard [](https://prometheus.io/) for cloud native monitoring

Graduated project of CNCF [](https://www.cncf.io/projects/prometheus/)

### Internals

![](100_monitoring/prometheus/prometheus.drawio.svg) <!-- .element: style="float: right; width: 60%; margin-left: 1em;" -->

Exporters offer metrics for retrieval

Prometheus scrapes data from exporters

Metrics are stored in a time series database (TSDB)

Query language PromQL

---

## Cluster metrics

All components provide a metrics endpoint:

- kube-apiserver
- coredns
- kube-controller-manager
- kube-proxy
- kube-scheduler
- kubelet

Prometheus should scrape all of them...

...but does not out-of-the-box

---

## Scrape configuration

Configure Prometheus to scrape targets [](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)

- Read from app with metrics endpoints
- Read from central exporter which reads from app
- Read from app with integrated exporter sidecar

```yaml
scrape_configs:
- job_name: 'example-target-1'
  scrape_interval: 5s
  static_configs:
    - targets: ['localhost:8090']
      labels:
        group: 'dummy'
- job_name: 'example-target-2'
  metrics_path: /api/metrics
  static_configs:
    - targets: ['localhost:8080']
      labels:
        group: 'dummy-2'
```
<!-- .element: style="width: 45em;" -->

---

## Prometheus Operator [](https://github.com/prometheus-operator/prometheus-operator)

![](images/logos/prometheus-operator.svg) <!-- .element: style="float: right; width: 4em;" -->

...because scrape configs are not fun to maintain!

### Features

Creates, updates and configures Prometheus automagically

Ships with multiple custom resource definitions:

- `Prometheus` for Prometheus instances

- `ServiceMonitor` for scraping pods behind a service

- `PodMonitor` for scraping individual pods

---

## Metrics collection

![](100_monitoring/prometheus/cluster_scraping.drawio.svg) <!-- .element: style="width: 100%;" -->

---

## Demo: Prometheus Operator

Explore managed instances

Explore (Pod|Service)Monitors for cluster components

View targets in [Prometheus web UI](http://prometheus.inmylab.de)

Test graph in [Prometheus web UI](http://prometheus.inmylab.de)
