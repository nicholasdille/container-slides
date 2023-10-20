## Host metrics

Can containers use all resources? Yes, but they should not!

Some reservations are necessary [](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)

![](100_monitoring/prometheus/reservations.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

### Operating system

Reserved for system services

### Kubernetes

Reserved for cluster components

### Further resources

Instance calculator for cloud providers [](https://learnk8s.io/kubernetes-instance-calculator)

Read reservations from managed cluster [](https://github.com/learnk8s/kubernetes-resource-inspector)

---

## CPU Reservations in Managed Kubernetes

Major cloud providers agree

XXX link to docs and rules

| Cores | Reservation    | Cumulative | Efficiency |
|-------|---------------:|-----------:|-----------:|
| 1     |   60m          | 60m        | 94.0%      |
| 2     | + 10m          | 70m        | 96.5%      |
| 4     | + 10m          | 80m        | 98.0%      |
| 8     | + 10m          | 90m        | 99.0%      |

---

## Memory reservations in Managed Kubernetes

Most major cloud providers agree

AWS uses: 255MiB + 11MiB * MAX_PODS

XXX link to docs and rules

| Memory | Reservation | Cumulative | Efficiency |
|--------|------------:|-----------:|-----------:|
| 0      |   255MiB    | 255MiB     |            |
| 4GiB   | + 800MiB    | 1055MiB    | 73.7%      |
| 8GiB   | + 800GiB    | 1855MiB    | 76,8%      |
| 112GiB | + 672MiB    | 2527MiB    | 97.7%      |
| 128GiB | + 256MiB    | 2783MiB    | 97.8%      |

---

## Configure Reservations

`kubelet` flags:

```plaintext
--system-reserved=memory=500Mi,cpu=100m
--kube-reserved=memory=500Mi,cpu=100m
```

Implementation depends on deployment

For example in `kind`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        system-reserved: memory=12Gi,cpu=2000m
        kube-reserved: memory=100Mi,cpu=100m
```

---

## Host metrics collection

node-exporter [](https://github.com/prometheus/node_exporter) collects host metrics...

...and exports them for scraping

Metrics [](https://github.com/prometheus/node_exporter#collectors) include CPU, memory, disk, network and a lot more!

Some are disabled by default [](https://github.com/prometheus/node_exporter#disabled-by-default)

### Demo

Start Kubernetes API proxy:

```bash
kubectl proxy
```

Read metrics endpoint:

```bash
NS=kube-system
SVC=node-exporter-prometheus-node-exporter
curl -s localhost:8001/api/v1/namespaces/${NS}/services/${SVC}:metrics/proxy/metrics \
| grep node_cpu_seconds_total
```
