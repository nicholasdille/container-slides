## `kube-state-metrics`

Metrics derived from cluster and resources

Project page [](https://github.com/kubernetes/kube-state-metrics)

### Exposed Metrics (exerpt)

For every resources:

- *_info
- *_labels
- *_annotations

Full list of metrics [](https://github.com/kubernetes/kube-state-metrics/tree/main/docs#exposed-metrics)

Very useful for joins against other metrics [](https://github.com/kubernetes/kube-state-metrics/tree/main/docs#join-metrics)

---

## Demo: `kube-state-metrics`

```bash
kubectl proxy

H=localhost:8001
NS=kube-system
S=kube-state-metrics
curl -s $H/api/v1/namespaces/$N/services/$S:http/proxy/metrics
```