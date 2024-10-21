## How to write roles 1/

(Cluster)Roles require verbs and (sub)resources

```yaml [6-7]
#...
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### How to find resources

Find supported resources:

```bash
kubectl api-resources
```

---

## How to write roles 2/

(Cluster)Roles require verbs and (sub)resources

```yaml [6-7]
#...
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### How to find verbs

Accepted verbs [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb): Create, get, list, watch, update, patch, delete

Find supported verbs for resources:

```bash
kubectl api-resources --output wide
```

---

## How to write roles 3/3

(Cluster)Roles require verbs and (sub)resources

```yaml
- apiGroups: [""]
  resources: ["pods/portforward"]
  verbs: ["get", "list", "create"]
```

### Subresources

Some resources have subresources, e.g. `pods/portforward`

```bash
kubectl get --raw / | jq -r '.paths[]' | grep "^/apis/" 
| while read -r API; do
    echo "=== ${API}"
    kubectl get --raw "${API}" \
    | jq -r 'select(.resources != null) | .resources[].name'
done
```

---

## How to specify subjects

Subjects [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects) are referenced in (Cluster)RoleBindings

### ServiceAccount

Can be created: `kubectl create sa <name>`

Token authentication maps to service accounts

Internally referenced by `system:serviceaccount:<ns>:<name>`

### User / Group

Authentication backends can add users and groups

Certificate authentication maps to users

---

## How to specify resource names

Limit access to specific resources using `resourceNames`

```yaml [9]
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: configmap-updater
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["my-configmap"]
  verbs: ["get", "update"]
```
