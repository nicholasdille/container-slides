# Quick actions

Use kubectl in pipes.

## Preparation

None

## Demo 1

Show environment variables of multiple pods:

```sh
kubectl get pod -l app=db -o name \
| xargs -I{} \
    kubectl exec -i {} -- printenv
```

Run a command in the first pod:

```sh
kubectl get pod --selector=app=web --output=name \
| head -n 1 \
| cut -d/ -f2 \
| xargs -I{} \
    kubectl exec {} -- dig +short web
```

...or better:

```sh
kubectl get pod --selector=app=web --output=json \
| jq --raw-output '.items[].metadata.name' \
| head -n 1 \
| xargs -I{} \
    kubectl exec {} -- dig +short web
```

...even better:

```sh
kubectl get pod --selector=app=web --output=json \
| jq --raw-output '.items[0].metadata.name' \
| xargs -I{} \
    kubectl exec {} -- dig +short web
```

## Demo 2

Delete all pods with a specific label:

```sh
kubectl get pods -l app.kubernetes.io/name=mimir --output=name \
| while read -r pod; do \
    kubectl delete "$pod"; \
done
```

...easier:

```sh
kubectl get pods -l app.kubernetes.io/name=mimir --output=name \
| xargs -n 1 kubectl delete
```

...even easier:

```sh
kubectl get pods -l app.kubernetes.io/name=mimir --all
```

## Cleanup

None