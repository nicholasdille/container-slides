# Service Accounts

Make sure to prepare your environment according to `prepare.sh`.

Show kubernetes service

```shell
kubectl get service kubernetes
```

Create sa

```shell
kubectl create sa foo
```

Create permanent token for service account

```shell
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

Check for permenent token

```shell
kubectl get secrets
kubectl get secrets foo-token -o json | jq --raw-output '.data.token' | base64 -d
```

Test token

```shell
TOKEN="$(kubectl get secrets foo-token -o json | jq --raw-output '.data.token' | base64 -d)"
kubectl --token="${TOKEN}" auth can-i get pods
```

Create short-lived token

```shell
TOKEN="$(kubectl create token foo --duration=10m)"
kubectl --token="${TOKEN}" auth can-i get pods
```
