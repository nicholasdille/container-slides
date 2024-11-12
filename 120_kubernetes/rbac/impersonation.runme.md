# Impersonation using RBAC

Deploy namespace

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: test
EOF
```

Deploy namespace admin

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: admin
  namespace: test
rules:
- apiGroups:
  - "*"
  resources:
  - "*"
  verbs:
  - "*"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin
  namespace: test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: admin
subjects:
- kind: User
  name: test-admin
EOF
```

Deploy service account in namespace

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: reader
  namespace: test
---
apiVersion: v1
kind: Secret
metadata:
  name: reader
  namespace: test
  annotations:
    kubernetes.io/service-account.name: reader
type: kubernetes.io/service-account-token
EOF

```

Deploy role and rolebinding in namespace

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: reader
  namespace: test
rules:
- apiGroups:
  - "*"
  resources:
  - "*"
  verbs:
  - "get"
  - "list"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: reader
  namespace: test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: reader
subjects:
- kind: ServiceAccount
  name: reader
  namespace: test
EOF
```

Deploy impersonation role

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: admin-impersonator
rules:
- apiGroups:
  - ""
  resources:
  - "users"
  verbs:
  - "impersonate"
  resourceNames:
  - "test-admin"
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-impersonator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin-impersonator
subjects:
- kind: ServiceAccount
  name: reader
  namespace: test
EOF
```

Create user in kubeconfig

```sh
TOKEN="$(
    kubectl -n test get secrets reader --output json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl config set-credentials test-reader --token=${TOKEN}
kubectl config set-context kind-test --user=test-reader --cluster=kind-kind
```

Switch namespace

```sh
kubectl config use-context kind-test
```

Show permissions in namespace test

```sh
kubectl auth can-i --list --namespace test
```

Succeed to access to namespace test

```sh
kubectl -n test get all
```

Fail to access namespace default

```sh
kubectl -n default get all
```

Fail to run pod in namespace test

```sh
kubectl -n test run -it --image=alpine --command -- sh
```

Run pod in namespace test using impersonation

```sh
kubectl -n test run -it --image=alpine --command --as=test-admin -- sh
```

Fail to remove pod

```sh
kubectl -n test delete pod sh
```

Remove pod using impersonation

```sh
kubectl -n test delete pod sh --as=test-admin
```
