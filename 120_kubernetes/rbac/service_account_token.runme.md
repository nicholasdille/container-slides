# Service Account Tokens

Make sure to prepare your environment according to `prepare.sh`.

Show kubernetes service

```sh
kubectl get service kubernetes
```

Create sa

```sh
kubectl create sa foo
```

Create permanent token for service account

```sh
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

```sh
kubectl get secrets
kubectl get secrets foo-token -o json | jq --raw-output '.data.token' | base64 -d
```

Test token

```sh
TOKEN="$(kubectl get secrets foo-token -o json | jq --raw-output '.data.token' | base64 -d)"
kubectl --token="${TOKEN}" auth can-i get pods
```

Create short-lived token

```sh
TOKEN="$(kubectl create token foo --duration=10m)"
kubectl --token="${TOKEN}" auth can-i get pods
```
