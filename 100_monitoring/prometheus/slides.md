## Scope

![](100_monitoring/prometheus/logo.svg) <!-- .element: style="float: right; width: 4em;" -->

Prometheus [](https://prometheus.io/) for cloud native monitoring

Graduated project of CNCF [](https://www.cncf.io/projects/prometheus/)

### Internals

![](100_monitoring/prometheus/prometheus.drawio.svg) <!-- .element: style="float: right; width: 50%;" -->

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

Prometheus should scrape all of them

XX but does not out-of-the-box

---

## Scrape configuration

Configure Prometheus to scrape targets [](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config)

- Read from app with metrics endpoints
- Read from central exporter which reads from app
- Read from app with exporter sidecar

Small scrape config:

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

---

## Prometheus Operator

...because scrape configs are not fun to maintain!

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
