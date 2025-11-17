# Wide Output

Details without wide output.

## Preparation

Two panes, vertical split

## Demo

Apply the deployment in pane 1:

```bash
kubectl apply -f deployment
```

Display pods with wide output and note line breaks making the output unreadable:

```bash
kubectl get pods -o wide
```

Use output type `custom-columns` to display desired fields only:

```bash
kubectl get pods -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,HOST:.spec.nodeName
```

## Cleanup

Remove everything:

```bash
kubectl delete -f deployment.yaml
```
