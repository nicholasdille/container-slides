# Default Service Account

Make sure to prepare your environment according to `prepare.sh`.

Show kubernetes service

```sh
kubectl get service kubernetes
```

Check service accounts

```sh
kubectl get sa
```

Run pod

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: default-test
spec:
  containers:
  - name: foo
    image: alpine
    command:
    - sh
    args:
    - -c
    - sleep 3600
EOF
```

Check pod description for default service account

```sh
kubectl get pod default-test -o yaml
```

Check pod for credentials

```sh
kubectl exec -it default-test -- mount | grep secrets
kubectl exec -it default-test -- ls -l /run/secrets/kubernetes.io/serviceaccount
```
