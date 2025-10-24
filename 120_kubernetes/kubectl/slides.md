# Divide and conquer

---

## Eventual consistency

Wait for deployments to complete

Two options

| `kubectl wait`                           | `kubectl rollout status`             |
|------------------------------------------|--------------------------------------|
| Wait for a condition on a resource       | Monitor the progress of a rollout    |
| Applies to many resources and conditions | Specialized for workload controllers |
| Single success message                   | Streaming output of rollout progress |


Demo:
- Deployment with long-running init container
- Run `kubectl get pods` regularly
- Run `kubectl rollout status deployment/waiting`
- Run `kubectl wait --for=condition=available --timeout=60s deployment/waiting`
- `kubectl exec -it deployment/waiting -c init-wait -- touch /tmp/initialized`

---

## Watching changes

Monitor the progress of a change

Two options

| `kubectl get pods --watch`     | `watch kubectl get pods`   |
|--------------------------------|----------------------------|
| Streaming output of changes    | Regularly runs the command |
| Hard to read for many replicas | Truncated to screen height |

Demo:
- `kubectl get pods --watch` updates on new events
- `kubectl scale deployment waiting --replicas 10` - becomes hard to read for many replicas
- Better `watch kubectl get pods`
- Only top lines are shown

### Filter output of `watch`

Does not work: `watch kubectl get pods | grep foo`

Does work: `watch "kubectl get pods | grep foo"`

Enter quoting hell

---

## Selecting objects

Production cluster have too many resources

### Option 1

Filter on `metadata.labels` using `--selector`

```shell
kubectl get --selector=app=foo
```

Demo:
- kwok
- Many deployments with countless pods
- kgp is too long
- kgp --selector=app=foo
- kubectl get pods --show-labels

### Option 2

Filter on some fields using `--field-selector` [](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)

```shell
kubectl get --field-selector="metadata.namespace!=kube-system"
```

Demo:
- ???

---

## Less typing

Always have shell completion ready (`kubectl completion bash|zsh|fish`)

Avoid pod names:
- Logs: `kubectl logs deployment/typing`
- Exec: `kubectl exec -it deployment/typing -- bash`

Use shortcut for ` kubectl`:
- Create alias: `alias k=kubectl`
- Add shell completion: `complete -F __start_kubectl k`

---

## Multiple resources at once

Show only required resources: `kubectl get pod,svc,secrets,cm`

Also works for named resources: `kubectl get rc/web service/frontend`

Ignore missing resources types: `kubectl get deploy/gone --ignore-not-found`

`kubectl get all` is just an alias for `kubectl get pod,svc,rs,deploy,sts,ds,jobs,cronjobs`

---

## Don't leave the console (MOVE?)

XXX `kubectl explain`

---

# Emperor's new cloths

---

## Little known outputs (REMOVE?)

XXX --output https://kubernetes.io/docs/reference/kubectl/#output-options

XXX YAML for humans

XXX JSON for machines

XXX describe vs. output

XXX server-side printing (`--server-print=false`)

---

## KYAML

Client-side processing

Requires `kubectl` 1.34+ [](https://kubernetes.io/blog/2025/07/28/kubernetes-v1-34-sneak-peek/#support-for-kyaml-a-kubernetes-dialect-of-yaml)

Hidden behind feature flag: `export KUBECTL_KYAML=true`

Finally: `kubectl get pod --output kyaml`

---

## Wide is too wide (REMOVE?)

`kubectl get pods` often misses interesting fields

`kubectl get pod --output wide` is two wide

Hard to read when working with multiple panes

### Enter `custom-columns`

`kubectl get pod --output custom-columns=NAME:.metadata.name,STATUS:.status.phase`

### Sorting

`kubectl get pod --all-namespaces --sort-by=.metadata.name`

---

# Console grind

---

## Processing JSON

XXX avoid text parsing

XXX `--no-headers`

jq vs. jsonpath https://kubernetes.io/docs/reference/kubectl/jsonpath/

---

## Go Templating

kubectl get no -o go-template='{{range .items}}{{if .spec.unschedulable}}{{.metadata.name}} {{.spec.externalID}}{{"\n"}}{{end}}{{end}}'

---

## Quick actions

kubectl ... | xargs ...

---

## Complex actions

kubectl ... | while read -r ...

---

## Long vs. short parameters

XXX `-o` vs. `--output`

XXX short on console

XXX long in scripts

---

# State affairs

---

## Diffing local and remote state

kubectl diff -k ./dir/

KUBECTL_EXTERNAL_DIFF=meld kubectl diff -k ./dir/

---

## patch vs. edit

kubectl edit

kubectl patch

---

## Create manifests

preserve idempotency

kubectl create secret --dry-run | kubectl apply -f -

---

# Release the kraken

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

https://direnv.net/

```shell
$ cat .envrc
export KUBECONFIG=~/.kube/config.my-cluster
export KUBECTL_CONTEXT=my-cluster-admin
```

---

## OIDC

XXX kubelogin https://github.com/int128/kubelogin

---

# All roads lead to Rome

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

---

# Better together

---

## Plugins

krew https://krew.sigs.k8s.io/plugins/

XXX https://github.com/GoogleCloudPlatform/kubectl-ai

XXX https://github.com/knight42/kubectl-blame

XXX https://github.com/ahmetb/kubectl-foreach

XXX https://github.com/kvaps/kubectl-node-shell

---

# Bonus: Shell-based Controller

---

## Watching events

`kubectl get pods --watch --output=json`

Alternative: https://github.com/flant/shell-operator
