# Create Manifests

Create manifests on the fly.

## Preparation

None

## Demo

Create a manifest for a secret:

```bash
kubectl create secret docker-registry reg.my-corp.io --dry-run=client --output=yaml \
    --docker-server=reg.my-corp.io \
    --docker-email=me@my-corp.io \
    --docker-username=me \
    --docker-password=Secr3t
```

## Cleanup

None
