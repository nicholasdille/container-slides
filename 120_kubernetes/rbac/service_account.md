## Pod Service Accounts

Pods can access the Kubernetes API

Special service called `kubernetes` present in every namespace

Pods automatically mounts service account token

By default, service account `default` is used

Service account `default` does not have any (Cluster)Role

---

## Prevent token mounting 1/

No need to Kubernetes API? Disable token mounting in `Pod`:

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

Don't want the service account to be mounted?

Disable token mounting in `ServiceAccount`:

```yaml [2,5]
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
automountServiceAccountToken: false
#...
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Service account with custom permissions

Some services require specific permissions

Use RBAC to provide only required permissions

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Service accounts without token

Service accounts are created without corresponding `Secret` [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Introduced in Kubernetes 1.24

Automounted service accounts always get a temporary token

Create special secret to force token creation:

```bash [2,7-9]
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

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")