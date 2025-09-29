# Demo

## Preparation

Run `kind` with `kwok` for real and faked workloads:

```bash
kwokctl create cluster --name=kwok --runtime=kind --enable=metrics-server
curl -sSLf https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/kwok.yaml | kubectl apply -f -
curl -sSLf https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/stage-fast.yaml | kubectl apply -f -
curl -sSLfO https://github.com/kubernetes-sigs/kwok/releases/download/v0.7.0/metrics-usage.yaml | kubectl apply -f -
```

Create nodes and pods:

```bash
kubectl apply -f kwok.yaml
```

Remove cluster:

```bash
kwokctl delete cluster --name=kwok
```
