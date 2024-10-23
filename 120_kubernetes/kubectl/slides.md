## `kubectl`

### Console grind

kubectl apply -f ./dir

kubectl get --selector

kubectl wait?

kubectl rollout status?

kubectl explain

completion

### Finding the needle in the haystack

kubectl get pod,svc,secrets,cm

--output https://kubernetes.io/docs/reference/kubectl/#output-options

jq

kubectl get pod -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

jsonpath https://kubernetes.io/docs/reference/kubectl/jsonpath/

### kubeconfig shenanigans

`$HOME/.kube/config`

`export KUBECONFIG`

`kubectl --kubeconfig`

`export KUBECONFIG=a:b`

`direnv`

### ???

kubectl exec -it deployment/foo -- bash

kubectl edit

kubectl patch

kubectl ... | xargs ...

kubectl ... | while read -r ...

### Preserve idempotency

kubectl create secret --dry-run | kubectl apply -f -

### Better together

plugins
