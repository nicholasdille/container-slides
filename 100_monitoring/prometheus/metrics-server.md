## metrics-server [](https://github.com/kubernetes-sigs/metrics-server/)

Provides an API for metrics collected by kubelet

Required for `kubectl top`

Required for Horizontal/Vertical Pod AutoScaler

### Demo 1/

View table of all nodes:

```bash
kubectl top node
```

View table of all pods in the current namespace:

```bash
kubectl top pod
```

---

## metrics-server [](https://github.com/kubernetes-sigs/metrics-server/)

Provides an API for metrics collected by kubelet

Required for `kubectl top`

Required for Horizontal Pod AutoScaler

### Demo 2/2

Get node state:

```bash
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes/kind-worker \
| jq
```

Get pod state:

```bash
NS=kube-system
POD=etcd-kind-control-plane
kubectl get --raw \
    "/apis/metrics.k8s.io/v1beta1/namespaces/${NS}/pods/${POD}" \
| jq
```
