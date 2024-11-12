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

Create pod with service account

```shell
cat <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: foo-automount
spec:
  serviceAccountName: foo
  automountServiceAccountToken: true
  containers:
  - name: nginx
    image: nginx:stable
EOF
```

Check automounted service account

```shell
kubectl exec -it foo -- mount | grep secrets
kubectl exec -it foo -- ls -l /run/secrets/kubernetes.io/serviceaccount
```

Create pod without service account

```shell
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo-noautomount
spec:
  serviceAccountName: foo
  automountServiceAccountToken: false
  containers:
  - name: nginx
    image: nginx:stable
EOF
```

Check for service account

```shell
kubectl exec -it foo -- mount | grep secrets
```
