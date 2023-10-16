## CI/CD

XXX version control because YAML is text

XXX separate instance for testing

---

## Cluster access 1/

XXX

### Inside cluster

XXX runner inside cluster with API access (RBAC)

![](120_kubernetes/ci_cd/inside.drawio.svg) <!-- .element: style="width: 50%;" -->

### Demo

XXX

---

## Cluster access 2/2

XXX

### Next to cluster

XXX runner side-by-side cluster

![](120_kubernetes/ci_cd/side-by-side.drawio.svg) <!-- .element: style="width: 50%;" -->

XXX fetches kubeconfig

### Demo

XXX

---

## Image tags

XXX immutable tags

XXX version pinning

---

## Horizontal pod autoscaler (HPA)

XXX

### Demo

XXX

---

## Taints / Tolerations

XXX

---

## Lessons Learnt 1/

### Avoid `kubectl create <resource>`

`kubectl create` is not idempotent

Instead create resource definition on-the-fly:

```bash
kubectl create secret --dry-run=client \
| kubectl apply -f -
```

---

## Lessons Learnt 2/

### Wait for reconciliation

XXX after apply, scale, delete

XXX do not sleep

```bash
kubectl wait --for=condition=ready pod/foo
kubectl rollout status deployment bar --timeout=15m
kubectl wait --for=condition=complete job/baz
```

---

## Lessons Learnt 3/

### Avoid hardcoded names

XXX

```bash
kubectl delete deployment --selector app=foo
```

---

## Lessons Learnt 4/

### Troubleshooting individual pods

XXX single pod in a ReplicaSet is broken

XXX remove label

```bash
kubectl label pod foo-12345 app-
```

XXX ReplicaSet replaces missing pod

XXX pod `foo-12345` can be investigated

---

## Lessons Learnt 5/

### Use plaintext in `Secret`

XXX

```yaml
#...
stringData:
  foo: bar
```

---

## Lessons Learnt 6/6

### Update dependencies

XXX even ops!
