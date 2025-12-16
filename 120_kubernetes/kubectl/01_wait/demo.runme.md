# Waiting

Demonstrate a long-running deployment and how to wait for it.

## Preparation

Two panes, horizontal split

## Demo 1

Start long-running deployment in pane 1:

```bash
kubectl apply -f deployment.yaml
```

Show manual testing in pane 1:

```bash
kubectl get pods
```

Wait for completed deployment in pane 2:

```bash
kubectl wait --for=condition=available --timeout=60s deployment/wait
```

Force deployment to finish:

```bash
kubectl exec -it deployment/wait -c init-wait -- touch /tmp/initialized
```

Check how the `wait` command completes.

## Demo 2

Start long-running deployment in pane 1:

```bash
kubectl apply -f deployment.yaml
```

Show manual testing in pane 1:

```bash
kubectl get pods
```

Wait for completed deployment in pane 2:

```bash
kubectl rollout status deployment wait
```

Force deployment to finish:

```bash
kubectl exec -it deployment/wait -c init-wait -- touch /tmp/initialized
```

Check how the `rollout status` command completes.

## Cleanup

Remove the deployment:

```bash
kubectl delete -f deployment.yaml
```
