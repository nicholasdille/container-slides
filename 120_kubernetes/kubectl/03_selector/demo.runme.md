# Selecting objects

XXX

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

- Many deployments with countless pods
- kgp is too long
- kgp --selector=app=foo
- kubectl get pods --show-labels

## Demo 2

- XXX

## Cleanup

```bash
kwokctl delete cluster --name=kwok
```
