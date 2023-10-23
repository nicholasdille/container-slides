## Metric sources

![](100_monitoring/prometheus/layers.drawio.svg)<!-- .element: style="width: 50%;" -->

<!-- .element: style="width: 90%;" -->

---

## Collection strategies

How metrics can be collected...

![](100_monitoring/prometheus/push.drawio.svg) <!-- .element: style="width: 45%; float: right;" -->

### Push <i class="fa-duotone fa-person-dolly"></i>

Metrics are delivered to database

Usually involves an agent

Example: Telegraf agent and InfluxDB

### Pull <i class="fa-duotone fa-cart-shopping"></i>

![](100_monitoring/prometheus/pull.drawio.svg) <!-- .element: style="width:45%; float: right;" -->

Database scrapes metrics

Either app-integrated or sidecar pattern

Example: Exporters and Prometheus
