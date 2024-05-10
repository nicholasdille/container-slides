## Pod Service Accounts

Pods can access the Kubernetes API

![](120_kubernetes/rbac/service_account.drawio.svg) <!-- .element: style="float: right; width: 15%" -->

Special service called `kubernetes` present in `default` namespace

Pods get environment variables to find API endpoint

Pods automatically mounts service account token

By default, service account `default` is used

Service account `default` does not have any (Cluster)Role

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

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Prevent token mounting 2/2

Don't want a service account to be mounted?

```yaml [2,5]
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
automountServiceAccountToken: false
```

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

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

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

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Service accounts without token

Service accounts are created without corresponding `Secret` [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Introduced in Kubernetes 1.24

Automounted service accounts always get a temporary token

Create special secret to obtain long-lived token:

```bash [1-2,4,7-9]
kubectl create sa foo
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: foo-token
  annotations:
    kubernetes.io/service-account.name: foo
type: kubernetes.io/service-account-token
EOF
```

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Deleting a service account

![](120_kubernetes/rbac/recovery.drawio.svg) <!-- .element: style="float: right; width: 15%;" -->

Access to Kubernetes API stops working immediately

Credentials remain accessible by pod

### Recovery is not easy

Not enough to create a new service account with the same name

Issued token does not work for new service account

Restart of pod is required

---

## Short-lived tokens

Avoid long-lived tokens

Create short-lived tokens on-demand [](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount)

```bash
kubectl create token <sa>
```

Specify lifetime of token:

```bash
kubectl create token <sa> --duration 1h
```

Bind lifetime of token to another resource:

```bash
kubectl create token <sa> \
    --bound-object-kind <kind> \
    --bound-object-name <name>
```

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Image Pull Secrets

Usually added to pods description

### Tied to Service Account

Add image pull secret(s) to service account [](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#add-imagepullsecrets-to-a-service-account):

```yaml[2,5-6]
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
imagePullSecrets:
- name: my_reg_secret_name
```

Mount service account to a pod and check:

```bash
kubectl get pod bar -o=jsonpath='{.spec.imagePullSecrets[0].name}{"\n"}'
```

Works regardless of `automountServiceAccountToken`

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Avoid Service Accounts 1/2

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

Use field references in environment variables

Also supports `resourceFieldRef` to access resource requests and limits

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Avoid Service Accounts 2/2

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

Use downward API [](https://kubernetes.io/docs/tasks/inject-data-application/downward-api-volume-expose-pod-information/) to expose pod information

Volume of type `downwardAPI` provides pod information

### Demo [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")
