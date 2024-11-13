## Pod Service Accounts

Pods can access the Kubernetes API

![](120_kubernetes/rbac/service_account.drawio.svg) <!-- .element: style="float: right; width: 15%" -->

Special service called `kubernetes` present in `default` namespace

Pods get environment variables to find API endpoint

Pods automatically mounts service account token

By default, service account `default` is used

Service account `default` does not have any (Cluster)Role

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_default_sa.runme.md "service_account_default_sa.runme.md")

---

## Prevent token mounting 1/

No need to access Kubernetes API?

Disable token mounting in `Pod`:

```yaml [2,7]
apiVersion: v1
kind: Pod
metadata:
  name: foo
spec:
  serviceAccountName: foo
  automountServiceAccountToken: false
#...
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_automount.runme.md "service_account_automount.runme.md")

---

## Prevent token mounting 2/2

Can be overridden in the pod spec:

```yaml [2,6]
apiVersion: v1
kind: Pod
metadata:
  name: foo
spec:
  serviceAccountName: foo
  automountServiceAccountToken: true
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_automount.runme.md "service_account_automount.runme.md")

---

## Accessing the Kubernetes API<br/>from pods

Some services require specific permissions

Use RBAC to provide only required permissions

Access Kubernetes API using environment variables:

```bash
$ printenv | grep KUBERNETES_ | sort
#...
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_api.runme.md "service_account_api.runme.md")

---

## Long-lived service account tokens

Service accounts are created without corresponding `Secret` [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Create special secret to obtain long-lived token:

```yaml [2,5-7]
apiVersion: v1
kind: Secret
metadata:
  name: foo-token
  annotations:
    kubernetes.io/service-account.name: foo
type: kubernetes.io/service-account-token
```

<i class="fa-duotone fa-warning"></i> Avoid long-lived service account tokens

Automounted service accounts always get a temporary token

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_token.runme.md "service_account_token.runme.md")

---

## Short-lived service account tokens

Avoid long-lived tokens

Create short-lived tokens on-demand [](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount)

```bash
kubectl create token foo
kubectl create token bar --duration 1h
```

Bind lifetime of token to another resource:

```bash
kubectl create token baz \
    --bound-object-kind pod \
    --bound-object-name my-pod
```

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_token.runme.md "service_account_token.runme.md")

---

## Deleting a service account

![](120_kubernetes/rbac/recovery.drawio.svg) <!-- .element: style="float: right; width: 15%;" -->

Service account is deleted while being in use

### Effect

Access to Kubernetes API stops working immediately

Credentials remain accessible by pod

### Recovery is not easy

Issued tokens do not work for new service account

Restart of pod is required

---

## Image Pull Secrets

Add image pull secret(s) to service account [](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#add-imagepullsecrets-to-a-service-account):

```yaml[2,5-6]
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
imagePullSecrets:
- name: my_reg_secret_name
```

When a pod uses the service account, the secret is added to the pods

Check `imagePullSecrets` in `Pod` spec

Works regardless of `automountServiceAccountToken`

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_pull_secrets.runme.md "service_account_pull_secrets.runme.md")

---

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: foo
spec:
  containers:
  - name: foo
    image: nginx
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: MY_POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: MY_POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
```

<!-- .element: style="float: right; width: 24em;" -->

## Avoid Service Accounts 1/2

Use field references in environment variables

Also supports `resourceFieldRef` to access resource requests and limits

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_avoid_sa.runme.md "service_account_avoid_sa.runme.md")

---

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: bar
  labels:
    app: demo
    components: frontend
    version: "1"
spec:
  containers:
  - volumeMounts:
    - name: podinfo
      mountPath: /etc/podinfo
  volumes:
  - name: podinfo
    downwardAPI:
      items:
      - path: "labels"
        fieldRef:
          fieldPath: metadata.labels
```

<!-- .element: style="float: right; width: 25em;" -->

## Avoid Service Accounts 2/2

Use downward API [](https://kubernetes.io/docs/tasks/inject-data-application/downward-api-volume-expose-pod-information/) to expose pod information

Volume of type `downwardAPI` provides pod information

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account_avoid_sa.runme.md "service_account_avoid_sa.runme.md")
