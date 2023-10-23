## Container metrics primer

Collecting metrics for containers

Containers are based on cgroups

Start a container and retrieve ID:

```bash
docker run -d --name nginx nginx
ID="$(docker container inspect nginx | jq -r '.[].Id')""
```

Using high-level tools:

```bash
docker stats
systemd-cgtop
```

Directly from the kernel:

```bash
cat "/sys/fs/cgroup/pids/docker/${ID}/cgroup.procs"
cat "/sys/fs/cgroup/cpuacct/docker/${ID}/cpuacct.usage"
cat "/sys/fs/cgroup/memory/docker/${ID}/memory.usage_in_bytes"
```

---

## Container metrics in Kubernetes

`kubelet` is responsible for maintaining pods/containers on a node

### Metrics...

...are offered by `kubelet` as well

`kubelet` ships with cadvisor [](https://github.com/google/cadvisor)

Published under `/metrics/cadvisor/`

### Demo: cadvisor with Docker

Run `cadvisor` in `compose`

XXX docker-exporter https://github.com/0xERR0R/dex

---

## Demo: Container metrics in k8s 1/

Explore metrics using `kubeletctl` [](https://github.com/cyberark/kubeletctl)

```bash
IP="$(
    docker inspect \
        --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' \
        kind-worker
)"
TOKEN="$(
    kubectl get secrets kubelet -o json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl get secrets kubelet -o json \
| jq --raw-output '.data."ca.crt"' \
| base64 -d >ca.crt
kubeletctl \
    --server ${IP} \
    --cacert ca.crt \
    --token ${TOKEN} \
    metrics cadvisor | less
```
<!-- .element: style="width: 46em;" -->

---

## Demo: Container metrics in k8s 2/

Explore metrics using `curl`

```bash
IP="$(
    docker inspect \
        --format '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}'\
        kind-worker
)"
TOKEN="$(
    kubectl get secrets kubelet -o json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl get secrets kubelet -o json \
| jq --raw-output '.data."ca.crt"' \
| base64 -d >ca.crt
curl -skH "Authorization: Bearer ${TOKEN}" \
    "https://${IP}:10250/metrics/cadvisor" | less
curl -skH "Authorization: Bearer ${TOKEN}" \
    "https://${IP}:10250/metrics/cadvisor" \
| grep container_memory_usage_bytes | grep kube-proxy
```
<!-- .element: style="width: 46em;" -->

---

## OpenMetrics 1/

"...today's de-facto standard for transmitting cloud-native metrics at scale."

Specification [](https://openmetrics.io/)

### Types


- <span class="fa-li"><i class="fa-duotone fa-gauge-high"></i></span> Gauge
- <span class="fa-li"><i class="fa-duotone fa-arrow-down-1-9"></i></span> Counter
- <span class="fa-li"><i class="fa-duotone fa-chart-column"></i></span> Histogram
- <span class="fa-li"><i class="fa-duotone fa-ball-pile"></i></span> and more [](https://github.com/OpenObservability/OpenMetrics/blob/main/specification/OpenMetrics.md#metric-types)

<!-- .element: class="fa-ul" style="line-height: 1.5em;" -->

### Metadata

Metrics can have labels

Labels provide metadata for filtering

---

## OpenMetrics 2/

Example output of a metrics endpoint:

```plaintext
# TYPE acme_http_router_request_seconds summary
# UNIT acme_http_router_request_seconds seconds
# HELP acme_http_router_request_seconds Latency though all of ACME's HTTP request router.
acme_http_router_request_seconds_sum{path="/api/v1",method="GET"} 9036.32
acme_http_router_request_seconds_count{path="/api/v1",method="GET"} 807283.0
acme_http_router_request_seconds_created{path="/api/v1",method="GET"} 1605281325.0
acme_http_router_request_seconds_sum{path="/api/v2",method="POST"} 479.3
acme_http_router_request_seconds_count{path="/api/v2",method="POST"} 34.0
acme_http_router_request_seconds_created{path="/api/v2",method="POST"} 1605281325.0
# TYPE go_goroutines gauge
# HELP go_goroutines Number of goroutines that currently exist.
go_goroutines 69
# TYPE process_cpu_seconds counter
# UNIT process_cpu_seconds seconds
# HELP process_cpu_seconds Total user and system CPU time spent in seconds.
process_cpu_seconds_total 4.20072246e+06
```
<!-- .element: style="width: 47em;" -->

---

## OpenMetrics

Format:

```plaintext
name{labels} value [timestamp]
```

Labels provide context for...

- Namespace name
- Pod name
- Container name

For example:

```plaintext
container_memory_usage_bytes{
    namespace="kube-system",
    pod="kube-proxy-68mp4",
    container="kube-proxy"
} 1.4917632e+07 1669235346213
```
