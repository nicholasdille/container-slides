## Port forwarding

Forwarding of a local port to a resource in Kubernetes

Requires `kubectl`

Useful for development, testing and troubleshooting

### Demo: Port forwarding to a pod

```bash
kubectl port-forward pod/nginx 8080:80
curl -s localhost:8080
```

### Demo: Port forwarding to a service

This bypasses load balancing!

```bash
kubectl port-forward service/web 8080:80
curl -s localhost:8080
```
