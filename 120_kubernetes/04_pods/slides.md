## Containers in Kubernetes

### Pods

![Pod consist of two containers](120_kubernetes/04_pods/pod.drawio.svg) <!-- .element: style="float: right;" -->

One or more containers

Single network namespace

Smallest unit of deployment

### YAML

```yaml
top:
  array:
  - item1
  hash:
    key: value
```
<!-- .element: style="float: right; width: 35%;" -->

YAML is used to describe a pod
