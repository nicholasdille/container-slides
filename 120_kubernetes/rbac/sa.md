## Pod Service Accounts

XXX k8s API access

XXX sa `default` is automatically mounted

XXX no roles or rolebindings

---

## Prevent mounting for service account token

XXX no pod sa

```yaml
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

## Prevent mounting of service account token

XXX

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
automountServiceAccountToken: false
#...
```

---

XXX custom sa

---

## Service accounts now without token

XXX sa without token since 1.24 [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

```bash
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