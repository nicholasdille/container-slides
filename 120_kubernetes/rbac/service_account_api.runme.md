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

Custom service account

```shell
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups:
  - ""
  resources:
  - "pods"
  verbs:
  - "get"
  - "watch"
  - "list"  
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: ServiceAccount
  name: foo
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF
```

Check service account locally

```shell
kubectl get pods --as=system:serviceaccount:default:foo
```

Deploy pod with service account

```shell
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo-test
spec:
  serviceAccountName: foo
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

Check environment variables for Kubernetes API endpoint

```shell
kubectl exec -it foo-test -- printenv | grep KUBERNETES_ | sort
```

Check service account from pod

```shell
kubectl exec -it foo-test -- sh
apk udpate
apk add kubectl --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing
TOKEN="$(cat /run/secrets/kubernetes.io/serviceaccount/token)"
kubectl --server=https://${KUBERNETES_SERVICE_HOST}:${KUBERNETES_SERVICE_PORT_HTTPS} --certificate-authority=/run/secrets/kubernetes.io/serviceaccount/ca.crt --token="${TOKEN}" version
```
