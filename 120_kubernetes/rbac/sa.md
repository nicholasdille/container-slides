## Pod Service Accounts

Pods can access the Kubernetes API

XXX Demo: Show service? Show inside pod?

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

---

## Custom service account

XXX

---

## Service accounts now without token

Service accounts are created without corresponding `Secret` [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Introduced in Kubernetes 1.24

XXX mounting in pod?

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

Automounted service accounts always get a temporary token