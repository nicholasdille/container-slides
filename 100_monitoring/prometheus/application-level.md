## Application Level Monitoring

Many apps ship with integrated exporters

Many FOSS services have an exporter

Collection works just like for system services

If nothing available, use generic exporters

### `blackbox_exporter` [](https://github.com/prometheus/blackbox_exporter)

Probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC

XXX DEMO

### `json_exporter` [](https://github.com/prometheus-community/json_exporter)

Scraping of remote JSON by JSONPath [](https://goessner.net/articles/JsonPath/)

Alternative: JSON API datasource [](https://grafana.com/grafana/plugins/marcusolsson-json-datasource/)

---

## Application on the network

Different datacenters or restrictive firewalls

Check whether scraping is possible

Otherwise push metrics to gateway:

### `pushgateway` [](https://github.com/prometheus/pushgateway)

Helps with firewall traversal

Accepts metrics from apps or agents [](https://github.com/prometheus/pushgateway#command-line)

Caveat: Does not remove orphaned metrics

---

## Pod Quality-of-Service

Kubernetes will try really hard to protect pods

### Pod eviction

When resources on a node are depleted:

- `kube-scheduler` will stop scheduling pods to the node
- `kubelet` will evict pods

### How pods are "chosen"

Pods have a quality-of-service based on resource requests and limits [](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)

- Guaranteed: All container have resource identical requests and limits
- Burstable: At least one container has resource requests or limits
- Best effort: All container do not have resource requests or limits

Scheduling uses resource requests to find suitable node

---

## Pod Quality-of-Service

### Check QoS

```bash
kubectl get pods --all-namespaces --output=json \
| jq --raw-output '.items[] | "\(.metadata.name): \(.status.qosClass)"'
```
