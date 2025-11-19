# Selecting objects

Use selectors to find resources.

## Preparation

Run `kind` with `kwok` for real and faked workloads:

```bash
kwokctl create cluster --name=kwok --runtime=kind --enable=metrics-server
```

Install `kwok` CRDs:

```bash
curl -sSLf https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/kwok.yaml | kubectl apply -f -
```

Install `kwok` stages:

```bash
curl -sSLf https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/stage-fast.yaml | kubectl apply -f -
```

Install `kwok` metrics usage:

```bash
curl -sSLf https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/metrics-usage.yaml | kubectl apply -f -
```

Create nodes and pods:

```bash
kubectl apply -f kwok.yaml
```

## Demo 1

Use labels selectors to filter resources.

Too many pods:

```bash
kubectl get pods -A
```

How many are pods there:

```bash
kubectl get pods -A --no-headers | wc -l
```

How many Deployments are there:

```bash
kubectl get deployment -A
```

How many backend pods are there:

```bash
kubectl -n backend get pods --no-header | wc -l
```

Which labels are available:

```bash
kubectl -n backend get deployments.apps --show-labels
```

Show deployments owned by team 1:

```bash
kubectl get deployment -l owner=team1 -A --show-labels
```

## Demo 2

Use field selectors to filter resources.

Show all pods not contained in namespace `kube-system`:

```bash
kubectl get deployment -A --field-selector "metadata.namespace!=kube-system"
```

How many pods are running on node `kwok-node-9`:

```bash
kubectl get pods -A --field-selector "spec.nodeName=kwok-node-9" | wc -l
```

## Cleanup

Remove the whole cluster:

```bash
kwokctl delete cluster --name=kwok
```
