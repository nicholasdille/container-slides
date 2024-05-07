## Aggregating ClusterRoles

Automagically aggregate rules into new ClusterRoles [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      aggregate-to-monitoring: "true"
rules: []
```

<!-- .element: style="float: left; width: 24em;" -->

```yaml
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
```

<!-- .element: style="float: right; width: 25em;" -->

XXX DEMO?!

---

## Aggregation in user-facing rules

HEavily used in builtin ClusterRoles [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)

```yaml
#...
metadata:
  labels:
    rbac.authorization.k8s.io/aggregate-to-admin: "true"
    rbac.authorization.k8s.io/aggregate-to-edit: "true"
    rbac.authorization.k8s.io/aggregate-to-view: "true"
#...
```
