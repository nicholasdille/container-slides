# Aggregated ClusterRoles

Inspect individual ClusterRoles

```sh
kubectl get clusterrole -l rbac.authorization.k8s.io/aggregate-to-view=true
```

Create first ClusterRole

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-endpoints
  labels:
    aggregate-to-monitoring: "true"
rules:
- apiGroups: [""]
  resources: ["services", "endpointslices", "pods"]
  verbs: ["get", "list", "watch"]
EOF
```

Create second ClusterRole

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-deployments
  labels:
    aggregate-to-monitoring: "true"
rules:
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch"]
EOF
```

Display new ClusterRoles

```sh
kubectl get clusterrole -l aggregate-to-monitoring=true
```

Create receiving ClusterRole

```sh
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      aggregate-to-monitoring: "true"
rules: []
EOF
```

Show aggregated ClusterRole

```sh
kubectl get clusterrole monitoring -o yaml
```
