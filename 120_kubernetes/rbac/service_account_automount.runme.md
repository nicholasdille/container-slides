# Automounting Service Accounts

Make sure to prepare your environment according to `prepare.sh`.

Show kubernetes service

```sh
kubectl get service kubernetes
```

Create sa

```sh
kubectl create sa foo
```

Create pod with service account

```sh
cat <<EOF | kubectl apply -f -
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

```sh
kubectl exec -it foo-automount -- mount | grep secrets
kubectl exec -it foo-automount -- ls -l /run/secrets/kubernetes.io/serviceaccount
```

Create pod without service account

```sh
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

```sh
kubectl exec -it foo-noautomount -- mount | grep secrets
```
