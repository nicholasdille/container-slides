# Processing JSON

Programatically process the output.

## Preparation

Switch to namespace `backend`:

```sh
kubeswitch backend
```

## jsonpath

Select first pod:

```sh
kubectl get pods --output=jsonpath='{.items[0]}'

```

Show name of all pods:

```sh
kubectl get pods --output=jsonpath='{.items[*].metadata.name}'

```

Show all pods with start time:

```sh
kubectl get pods --output=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}'
```

Select pods with a specific label:

```sh
kubectl get pods --all-namespaces --output=jsonpath='{.items[?(@.metadata.labels.app=="service15")].metadata.name}'
```

## jq

Select first pod:

```sh
kubectl get pods --output=json | jq '.items[0]'

```

Show name of all pods:

```sh
kubectl get pods --output=json | jq --raw-output '.items[].metadata.name'

```

Show all pods with start time:

```sh
kubectl get pods --output=json | jq --raw-output '.items[] | "\(.metadata.name)\t\(.status.startTime)"'
```

Select pods with a specific label:

```sh
kubectl get pods --all-namespaces --output=json | jq --raw-output '.items[] | select(.metadata.labels.app == "service15") | .metadata.name'
```

## Cleanup

Return to default namespace:

```sh
kubeswitch default
```