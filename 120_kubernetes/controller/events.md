## Events

XXX

```bash
kubectl get pods --watch --output-watch-events --output json \
| jq -r '"\(.type): \(.object.metadata.name) \(.object.status.phase)"'
```

XXX metrics
