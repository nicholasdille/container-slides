# Watching

Watching the progress of a command.

## Preparation

Two panes, horizontal split

## Demo

Apply a deployment with a single replica in pane 1:

```bash
kubectl apply -f deployment.yaml
```

Start watching the progress in pane 2:

```bash
kubectl get pods --watch
```

Scale the deployment in pane 1 and see how the output becomes hard to read:

```bash
kubectl scale deployment wait --replicas 10
```

Use `watch` to trace the changes:

```bash
watch kubectl get pods
```

Scale the deployment again:

```bash
kubectl scale deployment wait --replicas 5
```

## Cleanup

Remove the deployment:

```bash
kubectl delete -f deployment.yaml
```
