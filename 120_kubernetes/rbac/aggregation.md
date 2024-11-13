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

<!-- .element: style="float: left; font-size: smaller; width: 25em;" -->

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

<!-- .element: style="float: right; font-size: smaller; width: 25em;" -->

Rules from ClusterRole `monitoring-endpoints` are aggregated into `monitoring` based on labels

Heavily used in builtin ClusterRoles [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)

- `rbac.authorization.k8s.io/aggregate-to-(admin|edit|view)`

--

## Demo  [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/aggregation.runme.md "aggregation.runme.md")

Inspect builtin ClusterRoles with aggregation

Create custom aggregation
