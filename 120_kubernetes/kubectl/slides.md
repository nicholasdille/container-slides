## Console grind

---

## Apply all files

XXX

```shell
kubectl apply -f ./dir
```

---

## Apply all files

XXX

```shell
cat *.yaml | envsubst | kubectl apply -f -
```

---

## Waiting

XXX kubectl wait

XXX kubectl rollout status

---

## Waiting

Watch vs. --watch

---

## Selecting objects

XXX the default

```shell
kubectl get --selector
```

XXX

```shell
kubectl get --field-selector (https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)
```

---

## Don't leave the console

XXX kubectl explain

---

## Less typing

XXX completion

XXX kubectl logs deployment/foo

XXX kubectl exec -it deployment/foo -- bash

---

## Finding the needle in the haystack

---

## XXX

kubectl get pods --show-labels

---

## Multiple resources at once

XXX kubectl get pod,svc,secrets,cm

XXX even with name: kubectl get rc/web service/frontend pods/web-pod-13je7

XXX --ignore-not-found

---

## Little known outputs

XXX --output https://kubernetes.io/docs/reference/kubectl/#output-options

XXX YAML for humans

XXX JSON for machines

---

## Custom columns

kubectl get pod -o custom-columns=NAME:.metadata.name,STATUS:.status.phase

---

## Sorting

kubectl ... --output=wide --sort-by=.metadata.name

---

## Processing JSON

jq vs. jsonpath https://kubernetes.io/docs/reference/kubectl/jsonpath/

---

## Go Templating

kubectl get no -o go-template='{{range .items}}{{if .spec.unschedulable}}{{.metadata.name}} {{.spec.externalID}}{{"\n"}}{{end}}{{end}}'

---

## Diffing local and remote state

kubectl diff -k ./dir/

KUBECTL_EXTERNAL_DIFF=meld kubectl diff -k ./dir/

---

## kubeconfig shenanigans

---

## Using a single file

`$HOME/.kube/config`

`export KUBECONFIG`

`kubectl --kubeconfig`

---

## Using multiple files

`export KUBECONFIG=a:b`

---

## direnv

`direnv`

---

## Shortcuts (a.k.a. no scripts) 

---

kubectl get deployment/foo

---

## patch vs. edit

kubectl edit

kubectl patch

---

## Quick actions

kubectl ... | xargs ...

---

## Complex actions

kubectl ... | while read -r ...

---

## Preserve idempotency

---

## Create manifests

kubectl create secret --dry-run | kubectl apply -f -

---

## Better together

---

plugins https://krew.sigs.k8s.io/plugins/

XXX https://github.com/GoogleCloudPlatform/kubectl-ai

XXX https://github.com/knight42/kubectl-blame

XXX https://github.com/ahmetb/kubectl-foreach

XXX https://github.com/kvaps/kubectl-node-shell

XXX https://github.com/int128/kubelogin

---

## API

---

## Only pods

Selecting services downgrades to pods

XXX kubectl port-forward svc/foo ...

---

## Without explicit authentication

kubectl get --raw

---

## Without port forwarding

API server proxy URLs https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls 

---

## XXX

Remote SOCKS5 https://kubernetes.io/docs/tasks/extend-kubernetes/socks5-proxy-access-api/

---

## XXX

kubectl proxy https://kubernetes.io/docs/reference/kubectl/generated/kubectl_proxy/

---

## Resources

---

## Links

https://kubectl.docs.kubernetes.io/
