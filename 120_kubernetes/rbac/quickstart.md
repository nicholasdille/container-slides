## Quick Recap

### (Cluster)Role

What resource(s) to access

Which permissions are granted

### (Cluster)RoleBinding

Who is granted access (subject)

Which role is granted

### Subjects

ServiceAccount

User / Group (more later)

---

## Role-Based Access Control (RBAC)

### Reminder

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "update", "patch"]
```

<!-- .element: style="float: right; width: 25em; padding-left: 1em;" -->

What resource(s) to access
- `apiGroups`
- `resources`

Which permissions are granted
- `verbs`

`ClusterRole` works in the same way

---

## Role-Based Access Control (RBAC)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: ServiceAccount
  name: test
- apiGroup: rbac.authorization.k8s.io
  kind: ServiceAccount
  name: demo
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

<!-- .element: style="float: right; width: 25em;" -->

### Reminder

Who is granted access
- `subjects`

Which role is granted
- `roleRef`

---

## Role-Based Access Control (RBAC)

### Namespaced

Define and assign roles inside a namespace using `Role`, `RoleBinding`

### Clustered

Define and assign roles for the whole cluster using `ClusterRole`, `ClusterRoleBinding`

### Mix and match:

Define roles for the whole cluster and assign them in a namespace

![](120_kubernetes/rbac/rbac2.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->
