# API Proxy

Use the API server to access ports.

## Preparation

Apply deployment and service:

```bash
kubectl apply -f deployment.yaml
```

## Demo

Check availability using `curl` from a pod:

```bash
kubectl run -it --rm --image=curlimages/curl --restart=Never -- curl simple
```

Check availability directly against the API using the `kubectl` proxy:

```bash
kubectl proxy
curl -s http://localhost:8001/api/v1/namespaces/default/services/simple/proxy/
```

Check availability directly against the API:

```bash
kubectl get --raw /api/v1/namespaces/default/services/simple/proxy/
```

## Cleanup

Remove deployment:

```bash
kubectl delete -f deployment.yaml
```
