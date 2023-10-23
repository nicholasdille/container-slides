<!-- .slide: data-transition="fade" -->

## metrics-server [](https://github.com/kubernetes-sigs/metrics-server/)

Provides an API for metrics collected by `kubelet`/`cadvisor`

Required for `kubectl top` and Horizontal/Vertical Pod AutoScaler

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

<!-- .slide: data-transition="fade" -->

## metrics-server [](https://github.com/kubernetes-sigs/metrics-server/)

Provides an API for metrics collected by `kubelet`/`cadvisor`

Required for `kubectl top` and Horizontal/Vertical Pod AutoScaler

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
