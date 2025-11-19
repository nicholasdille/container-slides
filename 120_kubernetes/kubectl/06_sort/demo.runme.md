# Sorting

Sort the output.

## Preparation

None

## Demo

Display pods in default order:

```bash
kubectl get pods
```

Display pods sorted by creation timestamp:

```bash
kubectl get pods --sort-by=.metadata.creationTimestamp
```

Display pods sorted by IP:

```bash
kubectl get pods --sort-by=.status.podIP
```

## Cleanup

Remove deployment:

```bash
kubectl delete -f deployment.yaml
```
