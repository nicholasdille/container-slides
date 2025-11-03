<i class="fa-duotone fa-solid fa-cake-slice fa-4x"></i> <!-- .element: style="float: right;" -->

# Divide and conquer

## Finding the needle in the haystack

---

## Eventual consistency

Wait for deployments to complete

Two options

| `kubectl wait`                           | `kubectl rollout status`             |
|------------------------------------------|--------------------------------------|
| Wait for a condition on a resource       | Monitor the progress of a rollout    |
| Applies to many resources and conditions | Specialized for workload controllers |
| Single success message                   | Streaming output of rollout progress |

Notes:

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

### Filter output of `watch`

- <i class="fa-duotone fa-solid fa-square-xmark" style="--fa-secondary-color: red;"></i>`watch kubectl get pods | grep foo`
- <i class="fa-duotone fa-solid fa-square-check" style="--fa-secondary-color: green;"></i>`watch "kubectl get pods | grep foo"`

<!-- .element: class="fa-ul" -->

Enter quoting hell

Notes:

Demo:
- `kubectl get pods --watch` updates on new events
- `kubectl scale deployment waiting --replicas 10` - becomes hard to read for many replicas
- Better `watch kubectl get pods`
- Only top lines are shown

---

## Selecting objects

Production cluster have too many resources

### Option 1

Filter on `metadata.labels` using `--selector`

```shell
kubectl get --selector=app=foo
```

### Option 2

Filter on some fields using `--field-selector` [](https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/)

```shell
kubectl get --field-selector="metadata.namespace!=kube-system"
```

Notes:

Demo 1:
- kwok
- Many deployments with countless pods
- kgp is too long
- kgp --selector=app=foo
- kubectl get pods --show-labels

Demo 2:
- XXX

---

## Less typing

Always have shell completion ready

```bash
kubectl completion bash|zsh|fish
```

Avoid pod names:

```bash
kubectl logs deployment/typing
kubectl exec -it deployment/typing -- bash
```

Use shortcut with shell completion:

```bash
alias k=kubectl
complete -F __start_kubectl k
```

---

## Multiple resources at once

Show only required resources:

```bash
kubectl get pod,svc,secrets,cm
```

Also works for named resources:

```bash
kubectl get rc/web service/frontend
```

Ignore missing resources types:

```bash
kubectl get deploy/gone --ignore-not-found
```

---

## Multiple resources at once

Fun fact:

```bash
kubectl get all
```

... is just an alias for...

```bash
kubectl get pod,svc,rs,deploy,sts,ds,jobs,cronjobs
```

---

## Don't leave the console (MOVE?)

XXX `kubectl explain`

---

<i class="fa-duotone fa-solid fa-shirt-jersey fa-4x"></i> <!-- .element: style="float: right;" -->

# Emperor's new cloths

XXX subtitle

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

Hidden behind feature flag:

```bash
export KUBECTL_KYAML=true
```

Finally:

```bash
kubectl get pod --output=kyaml
```

---

## Wide is too wide (REMOVE?)

`kubectl get pods` often misses interesting fields

`kubectl get pod --output wide` is two wide

### Enter `custom-columns`

XXX

```bash
kubectl get pod --output \
    custom-columns=NAME:.metadata.name,STATUS:.status.phase
```

---

## Sorting resources

XXX

```bash
kubectl get pod --all-namespaces --sort-by=.metadata.name
```

---

<i class="fa-duotone fa-solid fa-keyboard fa-4x"></i> <!-- .element: style="float: right;" -->

# Console grind

XXX subtitle

---

## Processing JSON

Avoid text parsing

But if you must, use `--no-headers`

### `--output=jsonpath={}`

XXX https://kubernetes.io/docs/reference/kubectl/jsonpath/

XXX IETF [RFC 9535](https://www.rfc-editor.org/rfc/rfc9535)

### `--output=json | jq`

XXX jq is the defacto standard for JSON **processing**

XXX https://jqlang.org/manual/

XXX more than just parsing

---

## Go Templating

kubectl get node --output=go-template='{{range .items}}{{if .spec.unschedulable}}{{.metadata.name}} {{.spec.externalID}}{{"\n"}}{{end}}{{end}}'

---

## Quick actions

Sometimes a oneliner is more helpful than a script, e.g.

- `kubectl ... | xargs ...`
- `kubectl ... | while read -r ...`

This is usually combined with jsonpath/json/go-template output

---

## Long vs. short parameters

Mind readability

Flag usually have a short and a long version

For example: `-o` vs. `--output`

Use the short flag on the console for speed

Use the long flag in scripts for readability

---

# State affairs

<i class="fa-duotone fa-solid fa-scale-balanced"></i>

XXX subtitle

---

## Diffing local and remote state

XXX

`kubectl diff -k ./dir/`

Even use your favourite `diff` tool:

`export KUBECTL_EXTERNAL_DIFF=delta`

### For scripting

XXX return codes

XXX 0 - no differences

XXX 1 - differences found

XXX >=2 - error

---

## Incremental updates

Always prefer automated approaches (GitOps, CI/CD)

### Manual changes

`kubectl edit`

XXX `KUBE_EDITOR` / `EDITOR`

### Scripted changes

`kubectl patch`

XXX https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/

XXX strategic merge - merge documents but arrays are either replaced or merged (determined in code, e.g. defaults to replace, podSpec.containers uses merge)

XXX JSON merge patch (https://tools.ietf.org/html/rfc7386)

XXX JSON patch (https://tools.ietf.org/html/rfc6902)

---

## Create manifests

Preserve idempotency

`kubectl create secret --dry-run | kubectl apply -f -`

---

# Release the kraken

<i class="fa-duotone fa-solid fa-octopus"></i>

XXX subtitle

---

## Using a single file

first `$HOME/.kube/config`

then `export KUBECONFIG`

last `kubectl --kubeconfig`

---

## Using multiple files

`export KUBECONFIG=a:b`

---

## Impersonation

XXX `kubectl --as=user --as-group=group`

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

<i class="fa-duotone fa-solid fa-crosshairs-simple"></i>

XXX subtitle

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

<i class="fa-duotone fa-solid fa-handshake"></i>

XXX

---

## Plugins

krew https://krew.sigs.k8s.io/plugins/

XXX https://github.com/GoogleCloudPlatform/kubectl-ai

XXX https://github.com/knight42/kubectl-blame

XXX https://github.com/ahmetb/kubectl-foreach

XXX https://github.com/kvaps/kubectl-node-shell

---

# Bonus: To Shell or not to Shell

<i class="fa-duotone fa-solid fa-hand-holding-skull"></i>

XXX subtitle

---

## Watching events

```bash
kubectl get namespaces --watch=true --output-watch-events=true --output=json | \
jq --compact-output --monochrome-output --unbuffered 'del(.object.metadata.managedFields)' | \
while read EVENT; do
    #
done
```

Alternative: https://github.com/flant/shell-operator
