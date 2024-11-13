# Automounting Service Accounts

Make sure to prepare your environment according to `prepare.sh`.

Show kubernetes service

```sh
kubectl get service kubernetes
```

Create sa and deny automounting

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo-noautomount
automountServiceAccountToken: false
EOF
```

Create pod with the service account

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo-automount
spec:
  serviceAccountName: foo-noautomount
  containers:
  - name: nginx
    image: nginx:stable
EOF
```

Check that the service account is not mounted

```sh
kubectl exec -it foo-automount -- mount | grep secrets || true
kubectl exec -it foo-automount -- ls -l /run/secrets/kubernetes.io/serviceaccount || true
```

Enforce automounting the service account

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo-enforce
spec:
  serviceAccountName: foo-noautomount
  automountServiceAccountToken: true
  containers:
  - name: nginx
    image: nginx:stable
EOF
```

Check automounted service account

```sh
kubectl exec -it foo-enforce -- mount | grep secrets || true
kubectl exec -it foo-enforce -- ls -l /run/secrets/kubernetes.io/serviceaccount || true
```

Create pod without service account

```sh
kubectl create sa foo
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
kubectl exec -it foo-noautomount -- mount | grep secrets || true
```
