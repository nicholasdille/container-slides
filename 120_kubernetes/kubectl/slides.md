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

Watch vs. --watch

### kubeconfig shenanigans

`$HOME/.kube/config`

`export KUBECONFIG`

`kubectl --kubeconfig`

`export KUBECONFIG=a:b`

`direnv`

### Shortcuts (a.k.a. no scripts) 

kubectl exec -it deployment/foo -- bash

kubectl port-forward svc/foo ... 

kubectl edit

kubectl patch

kubectl ... | xargs ...

kubectl ... | while read -r ...

### Preserve idempotency

kubectl create secret --dry-run | kubectl apply -f -

### Better together

plugins

### API

kubectl get --raw

kubectl proxy https://kubernetes.io/docs/reference/kubectl/generated/kubectl_proxy/

API server proxy URLs https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls 

Remote SOCKS5 https://kubernetes.io/docs/tasks/extend-kubernetes/socks5-proxy-access-api/ 
