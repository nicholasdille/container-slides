<i class="fa-duotone fa-solid fa-cake-slice fa-4x"></i> <!-- .element: style="float: right;" -->

## Divide and conquer

### Finding the needle in the haystack

---

## Eventual consistency

Wait for deployments to complete

Two options

| `kubectl wait`                           | `kubectl rollout status`             |
|------------------------------------------|--------------------------------------|
| Wait for a condition on a resource       | Monitor the progress of a rollout    |
| Applies to many resources and conditions | Specialized for workload controllers |
| Single success message                   | Streaming output of rollout progress |

### Demo (01_wait)

---

## Watching changes

Monitor the progress of a change

Two options

| `kubectl get pods --watch`     | `watch kubectl get pods`   |
|--------------------------------|----------------------------|
| Streaming output of changes    | Regularly runs the command |
| Hard to read for many replicas | Truncated to screen height |

### Filter output for `watch`

- <i class="fa-duotone fa-solid fa-square-xmark" style="--fa-secondary-color: red;"></i>`watch kubectl get pods | grep foo`
- <i class="fa-duotone fa-solid fa-square-check" style="--fa-secondary-color: green;"></i>`watch "kubectl get pods | grep foo"`

<!-- .element: class="fa-ul" -->

Enter quoting hell

### Demo (02_watch)

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

### Demo (03_selector)

---

## Less typing 1/2

Always have shell completion ready

```bash
kubectl completion bash|zsh|fish
```

Avoid pod names unless specific pod is required:

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

## Less typing 1/2

```yaml
# Suggested defaults as per
# https://kubernetes.io/docs/reference/kubectl/kuberc/#suggested-defaults
apiVersion: kubectl.config.k8s.io/v1beta1
kind: Preference
defaults:
  # (1) default server-side apply
  - command: apply
    options:
      - name: server-side
        default: "true"

  # (2) default interactive deletion
  - command: delete
    options:
      - name: interactive
        default: "true"
```

<!-- .element: style="float: right; height: 25em; width: 30em;" -->

Custom behaviour using `kuberc` [](https://kubernetes.io/docs/reference/kubectl/kuberc/)

Aliases are now first class citizens

Configure default options per subcommand

Suggested defaults [](https://kubernetes.io/docs/reference/kubectl/kuberc/#suggested-defaults)

---

## Multiple resources at once 1/2

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

## Multiple resources at once 2/2

Fun fact:

```bash
kubectl get all
```

... is just an alias for...

```bash
kubectl get pod,svc,rs,deploy,sts,ds,jobs,cronjobs
```

---

<!-- .slide: data-visibility="hidden" -->

## Don't leave the console (MOVE?)

XXX `kubectl explain`

---

<i class="fa-duotone fa-solid fa-shirt-jersey fa-4x"></i> <!-- .element: style="float: right;" -->

## Emperor's new cloths

### Styling the output

---

<!-- .slide: data-visibility="hidden" -->

## Little known outputs (REMOVE?)

XXX --output https://kubernetes.io/docs/reference/kubectl/#output-options

XXX YAML for humans

XXX JSON for machines

XXX describe vs. output

XXX server-side printing (`--server-print=false`)

---

## KYAML

Why? Shortcomings of YAML

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

### Demo (04_kyaml)

---

## Wide is too wide

`kubectl get pods` often misses interesting fields

`kubectl get pod --output wide` is two wide

### Enter `custom-columns`

Create columns from metadata, spec and status fields:

```bash
kubectl get pod --output \
    custom-columns=NAME:.metadata.name,STATUS:.status.phase,HOST:.spec.nodeName
```

### Demo (05_wide)

---

## Sorting resources

Change the order of displayed resources:

```bash
kubectl get pod --all-namespaces --sort-by=.metadata.name
```

### Demo (06_sort)

---

<i class="fa-duotone fa-solid fa-keyboard fa-4x"></i> <!-- .element: style="float: right;" -->

## Console grind

### Bulk processing manifests

---

## Processing JSON

Avoid text parsing with `grep`/`awk`/`sed`/`cut`/`tr`

But if you must, use `kubectl [...] --no-headers`

### Better: `--output=jsonpath={}`

`kubectl` supports JSONPath for filtering natively [](https://kubernetes.io/docs/reference/kubectl/jsonpath/)

Based on open standard RFC9535 [](https://www.rfc-editor.org/rfc/rfc9535)

### Also better: `--output=json | jq`

`jq` is the defacto standard for JSON **processing** [](https://jqlang.org/manual/)

More than just filtering

### Demo (07_json)

---

## Go Templating

De facto standard [](https://gotemplate.io/)

Integrated in `kubectl` for parsing manifests

### For example

```bash
kubectl get node --output=go-template=\
'{{range .items}}{{if .spec.unschedulable}}{{.metadata.name}} {{.spec.externalID}}{{"\n"}}{{end}}{{end}}'
```

### Demo (08_go_template)

---

## Quick actions

Sometimes a oneliner is more helpful than a script, e.g.

```bash
kubectl ... | xargs ...
kubectl ... | while read -r ...
```

This is usually combined with machine readable `--output`:
- `jsonpath`
- `json`
- `go-template`

### Demo (09_pipe)

---

## Long vs. short parameters

Think of readability

Flags usually have a short and a long version

For example: `-o` vs. `--output`

### When to use what

Short flag on the console for speed

Long flag in scripts for readability

---

<i class="fa-duotone fa-solid fa-scale-balanced fa-4x"></i> <!-- .element: style="float: right;" -->

## State affairs

### Updating resources

---

## Diffing local and remote state

Check for configuration drift:

```bash
kubectl diff -f deployment.yaml
```

Even use your favourite `diff` tool:

```bash
export KUBECTL_EXTERNAL_DIFF=delta
```

### Useful for scripting

| Return Code | Meaning              |
|-------------|----------------------|
| 0           | No differences found |
| 1           | Differences found    |
| >=2         | Error occurred       |

---

## Incremental updates 1/2

Always prefer automated approaches (GitOps, CI/CD)

### Manual changes <i class="fa-duotone fa-solid fa-thumbs-down"></i>

Update resource on-the-fly:

```bash
kubectl edit NAME
```

Use your favourite editor:

```bash
export KUBE_EDITOR=nano
```

`kubectl` also honours `EDITOR` environment variable

<i class="fa-duotone fa-solid fa-triangle-exclamation"></i> Vibe killer: Immutable fields <i class="fa-duotone fa-solid fa-triangle-exclamation"></i>

---

## Incremental updates 2/2

Always prefer automated approaches (GitOps, CI/CD)

### Scripted changes <i class="fa-duotone fa-solid fa-thumbs-up"></i>

Use `kubectl patch` with three options [](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/)

Strategic merge combines documents field by field

JSON merge patch [](https://tools.ietf.org/html/rfc7386)

JSON patch [](https://tools.ietf.org/html/rfc6902)

<i class="fa-duotone fa-solid fa-triangle-exclamation"></i> Vibe killer: Immutable fields <i class="fa-duotone fa-solid fa-triangle-exclamation"></i>

---

## Create manifests

Preserve idempotency

Secrets are affected

```bash
kubectl create secret docker-registry reg.my-corp.io --dry-run=client --output=yaml \
    --docker-server=reg.my-corp.io \
    --docker-email=me@my-corp.io \
    --docker-username=me \
    --docker-password=Secr3t \
| kubectl apply -f -
```

### Demo (10_create)

---

<i class="fa-duotone fa-solid fa-octopus fa-4x"></i> <!-- .element: style="float: right;" -->

## Release the kraken

### `kubeconfig` and multiple clusters

---

## Using a single file

`kubectl` looks for a `kubeconfig` in three places:

first `$HOME/.kube/config`

then `export KUBECONFIG`

last `kubectl --kubeconfig`

---

## Using multiple clusters

Don't we all?!

### Straight forward

Single `kubeconfig` file

Multiple clusters, users and contexts

### Alternative

Single `kubeconfig` file per cluster

Reference multiple files:

```bash
export KUBECONFIG=$HOME/.kube/config.dev:$HOME/.kube/config.prod
```

---

## Switching clusters and contexts

Builtin: `kubeconfig config use-context FOO`

E_COMMAND_TOO_LONG <i class="fa-duotone fa-solid fa-face-grin-wink"></i>

### `kubeswitch`

Minimal TUI for switching contexts and namespaces [](https://github.com/danielb42/kubeswitch)

### direnv

Load configuration when entering a directory [](https://direnv.net/)

For example:

```shell
$ cat .envrc
export KUBECONFIG=~/.kube/config.my-cluster
export KUBECTL_CONTEXT=my-cluster-admin
```

---

<!-- .slide: data-visibility="hidden" -->

## Open ID Connect

Avoid explicit credentials in `kubeconfig`

Use trusted identity provider, e.g. GitLab

Structured authentication configuration for mapping claims to users and groups [](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#using-authentication-configuration)

Use RBAC for permissions based on claims

Plugin `kubelogin` for local integration [](https://github.com/int128/kubelogin)

---

## Impersonation

Limit access to read-only

Allow impersonation for administrative tasks

For example:

```bash
kubectl --as=user --as-group=group
```

### Demo (11_impersonation)

---

<i class="fa-duotone fa-solid fa-crosshairs-simple fa-4x"></i> <!-- .element: style="float: right;" -->

## All roads lead to Rome

### How to reach a pod for testing

---

## Port forwarding

Connect a local port to a pod:

```bash
kubectl port-forward foo-012345678-abcde 8080:8080
```

### Only one pod

Selecting services downgrades to one pod

```bash
kubectl port-forward svc/foo 8080:8080
```

Not suited for testing load balancing

---

## Without port forwarding

API server brings a builtin proxy [](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls)

Format of proxy URL:

```plaintext
/api/v1/namespaces/NAMESPACE/services/[https:]SERVICE[:port_name]/proxy
```

Option 1:

```bash
$ kubectl proxy
$ curl -s http://127.0.0.1:8001/api/v1/namespaces/NAMESPACE/services/[https:]SERVICE[:port_name]/proxy
```

Option 2:

```bash
kubectl get --raw /api/v1/namespaces/NAMESPACE/services/[https:]SERVICE[:port_name]/proxy
```

### Demo (12_proxy)

---

<i class="fa-duotone fa-solid fa-handshake fa-4x"></i> <!-- .element: style="float: right;" -->

## Better together

### More features using plugins

---

## Noteworthy Plugins

Install plugins using `krew` [](https://krew.sigs.k8s.io/)

### Opinionated examples

kubectl-ai [](https://github.com/GoogleCloudPlatform/kubectl-ai) - Use agent to perform tasks

kubectl-blame [](https://github.com/knight42/kubectl-blame) - Use `managedFields` to show author per line

kubectl-foreach [](https://github.com/ahmetb/kubectl-foreach) - Run subcommands on multiple contexts

kubectl-node-shell [](https://github.com/kvaps/kubectl-node-shell) - Enter node shell without SSH

Many more plugins [](https://krew.sigs.k8s.io/plugins/)
