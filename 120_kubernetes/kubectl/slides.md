## ???

---

## Apply all files

In a directory:

```shell
kubectl apply -f ./dir/
```

Demo:
- ServiceAccount
- Role
- RoleBinding
- Deployment
- Service
- Certificate
- DNS
- Ingress
- ServiceMonitor

---

## Apply all files

With basic templating:

```shell
cat *.yaml | envsubst | kubectl apply -f -
```

Demo:
- Same as above but with...
- Variable `${NAMESPACE}`
- Variable `${IMAGE_TAG}`
- Variable `${DOMAIN}`
- Variable `${APP_NAME}`

Better use `helm` or `kustomize`

---

## Waiting for consistency

XXX kubectl wait

XXX kubectl rollout status

Demo:
- Deployment with long-running init container
- Run `kubectl get pods` regularly
- Run `kubectl rollout status deployment/waiting`
- Run `kubectl wait --for=condition=available --timeout=60s deployment/waiting`
- `kubectl exec -it deployment/waiting -c init-wait -- touch /tmp/initialized`

XXX difference?

---

## Watching changes

Watch vs. --watch

Demo:
- `kubectl get pods --watch` updates on new events
- `kubectl scale deployment waiting --replicas 10` - becomes hard to read for many replicas
- Better `watch kubectl get pods`
- Only top lines are shown

Does not work: `watch kubectl get pods | grep foo`

Does work: `watch "kubectl get pods | grep foo"`

Enter quoting hell

---

## Finding the needle in the haystack

---

## Selecting objects

XXX too many objects

XXX the default

XXX use `metadata.labels` as context

```shell
kubectl get --selector=app=foo
```

Demo:
- kwok
- Many deployments with countless pods
- kgp is too long
- kgp --selector=app=foo
- kubectl get pods --show-labels

XXX the complex

https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/

```shell
kubectl get --field-selector="metadata.namespace!=kube-system"
```

---

## Console grind

---

## Less typing

XXX completion `kubectl completion bash|zsh|fish`

XXX Show log of any pod with `kubectl logs deployment/typing`

XXX Enter any pod `kubectl exec -it deployment/typing -- bash`

XXX alias k `alias k=kubectl` with completion `complete -F __start_kubectl k`

---

## Multiple resources at once

XXX Show only required resources `kubectl get pod,svc,secrets,cm`

XXX even with name: `kubectl get rc/web service/frontend`

XXX Some may not exist: `--ignore-not-found`

XXX `kubectl get all` is just an alias for `kubectl get pod,svc,rs,deploy,sts,ds,jobs,cronjobs`

---

## Don't leave the console

XXX `kubectl explain`

---

## Long vs. short parameters

XXX `-o` vs. `--output`

XXX short on console

XXX long in scripts

---

## Little known outputs

XXX --output https://kubernetes.io/docs/reference/kubectl/#output-options

XXX YAML for humans

XXX JSON for machines

---

## KYAML

XXX client-side

XXX requires kubectl 1.34+ (https://kubernetes.io/blog/2025/07/28/kubernetes-v1-34-sneak-peek/#support-for-kyaml-a-kubernetes-dialect-of-yaml)

XXX `export KUBECTL_KYAML=true`

XXX `kubectl get pod --output kyaml`

---

## Custom tables

XXX output `custom-columns`

`kubectl get pod --output custom-columns=NAME:.metadata.name,STATUS:.status.phase`

---

## Sorting

`kubectl get pod --all-namespaces --sort-by=.metadata.name`

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

first `$HOME/.kube/config`

then `export KUBECONFIG`

last `kubectl --kubeconfig`

---

## Using multiple files

`export KUBECONFIG=a:b`

---

## direnv

`direnv`

---

## OIDC

XXX kubelogin https://github.com/int128/kubelogin

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

---

## API

---

## Only pods for port forwarding

Selecting services downgrades to pods

`kubectl port-forward svc/foo 8080:8080`

---

## Without explicit authentication

kubectl get --raw

---

## Without port forwarding

API server proxy URLs https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls
