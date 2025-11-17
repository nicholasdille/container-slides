# API Proxy

Use the API server to access ports.

## Preparation

XXX:

```bash
kubectl apply -f deployment.yaml
```

## Demo

XXX:

```bash
kubectl run -it --rm --image=curlimages/curl --restart=Never -- curl simple
```

XXX:

```bash
curl -s http://localhost:8001/api/v1/namespaces/default/services/simple/proxy/
```

## Cleanup

XXX:

```bash
kubectl delete -f deployment.yaml
```
