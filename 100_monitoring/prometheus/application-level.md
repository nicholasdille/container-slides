## Application Level Monitoring

XXX many apps ship with exporters

XXX many FOSS services have an exporter

XXX collection just like system services

XXX if not, use special exporters

### `blackbox_exporter` [](https://github.com/prometheus/blackbox_exporter)

Probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC

### `json_exporter` [](https://github.com/prometheus-community/json_exporter)

Scraping of remote JSON by JSONPath [](https://goessner.net/articles/JsonPath/)

---

## Application Location

XXX network

XXX datacenters, firewalls, policies, pull vs. push

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

Pods have a quiality-of-service based on resource requests and limits [](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)

- Best effort: All container have resource identical requests and limits
- Burstable: At least one container has resource requests or limits
- Guaranteed: All container do not have resource requests or limits

Scheduling uses resource requests to find suitable node

Notes:
Check pods for QoS
`kubectl get pods -A -o json | jq -r '.items[] | "\(.metadata.name): \(.status.qosClass)"'`
