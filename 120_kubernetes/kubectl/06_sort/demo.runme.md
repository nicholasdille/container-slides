# Sorting

XXX

## Preparation

XXX

## Demo

XXX:

```bash
kubectl get pods
```

XXX:

```bash
kubectl get pods --sort-by=.metadata.creationTimestamp
```

XXX:

```bash
kubectl get pods --sort-by=.status.podIP
```

## Cleanup

XXX

```bash
kubectl delete -f deployment.yaml
```
