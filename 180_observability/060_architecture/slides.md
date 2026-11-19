# Architecture

---

![](180_observability/media/mimir.svg) <!-- .element: style="width: 10%; float: right;" -->

## Mimir

Source:  [Grafana Mimir Architecture](https://grafana.com/docs/mimir/latest/get-started/about-grafana-mimir-architecture/about-ingest-storage-architecture/)

![](180_observability/060_architecture/mimir.drawio.svg) <!-- .element: style="width: 45%; float: right;" -->

### Deployment modes

Monolithic, scale monolithic, microservices [](https://grafana.com/docs/mimir/latest/references/architecture/deployment-modes/)

Helm only supports microservices mode

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/mimir/latest/manage/run-production-environment/planning-capacity/)

---

![](180_observability/media/loki.svg) <!-- .element: style="width: 7%; float: right;" -->

## Loki

Source:  [Grafana Loki Architecture](https://grafana.com/docs/loki/latest/get-started/architecture/)

![](180_observability/060_architecture/loki.drawio.svg) <!-- .element: style="width: 40%; float: right;" -->

### Deployment modes

Single binary, simple scalable deployment, microservices [](https://grafana.com/docs/loki/latest/get-started/components/) [](https://grafana.com/docs/loki/latest/get-started/deployment-modes/)

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/loki/latest/setup/size/)

---

![](180_observability/media/tempo.svg) <!-- .element: style="width: 7%; float: right;" -->

## Tempo

Source: [Tempo architecture](https://grafana.com/docs/tempo/latest/introduction/architecture/)

![](180_observability/060_architecture/tempo.drawio.svg) <!-- .element: style="width: 40%; float: right;" -->

### Deployment modes

Monolithic, microservices [](https://grafana.com/docs/tempo/latest/reference-tempo-architecture/deployment-modes/)

### Capacity Planning

Capacity Planning [](https://grafana.com/docs/tempo/latest/set-up-for-tracing/setup-tempo/plan/size/)
