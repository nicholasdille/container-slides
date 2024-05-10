## Aggregating ClusterRoles

Automagically aggregate rules into new ClusterRoles [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles)

```yaml [5-8]
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

```yaml [5-6]
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

Heavily used in builtin ClusterRoles [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)

- `rbac.authorization.k8s.io/aggregate-to-(admin|edit|view)`

---

## Demo  [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/aggregation.demo "aggregation.demo")

Inspect builtin ClusterRoles with aggregation

Create custom aggregation
