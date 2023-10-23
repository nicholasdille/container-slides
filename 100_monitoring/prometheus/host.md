## Host metrics

Can containers use all resources? Yes, but they should not!

Some reservations are necessary [](https://kubernetes.io/docs/tasks/administer-cluster/reserve-compute-resources/)

Capacity must be divided between system, cluster and containers

![](100_monitoring/prometheus/reservations.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

### Operating system

Reserved for system services

### Kubernetes

Reserved for cluster components

### Allocatable resources

`Allocatable = Capacity - System - Kubernetes`

---

## Reservations in Managed Kubernetes

Overview of AWS, Azure and Google Cloud [](https://learnk8s.io/allocatable-resources)

Larger VMs have less overhead

More VMs provide more availability

### Further reading

Instance calculator for cloud providers [](https://learnk8s.io/kubernetes-instance-calculator)

Read reservations from managed cluster [](https://github.com/learnk8s/kubernetes-resource-inspector)

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

`node-exporter` [](https://github.com/prometheus/node_exporter) collects host metrics...

...and exports them for scraping

Metrics [](https://github.com/prometheus/node_exporter#collectors) include CPU, memory, disk, network and a lot more!

Some are disabled but the defaults are reasonable [](https://github.com/prometheus/node_exporter#disabled-by-default)

### Demo

Start Kubernetes API proxy and read metrics endpoint:

```bash
kubectl proxy

H=localhost:8001
NS=kube-system
SVC=node-exporter-prometheus-node-exporter
curl -s $H/api/v1/namespaces/$NS/services/$SVC:metrics/proxy/metrics \
| grep node_cpu_seconds_total
```
