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
kubectl get pods -o=jsonpath='{.items[0]}'

```

Show name of all pods:

```sh
kubectl get pods -o=jsonpath='{.items[*].metadata.name}'

```

Show all pods with start time:

```sh
kubectl get pods -o=jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}'
```

## jq

XXX

## Cleanup

XXX