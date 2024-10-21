## RBAC Risks

### Secrets

Verb `get`, `list` and `watch` disclose the contents [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#listing-secrets)

Be very careful when allowing access to secrets

### Workload creation

New pods can use existing service accounts [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#workload-creation)

Pods obtain permissions of service accounts... even without `pods/exec`

### Namespace modification

Verb `patch` on namespace allows changing labels [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#namespace-modification)...

...and disabling of pod security admission as well as network policies

---

## RBAC Risks

### Escalate verb

Allows changing `(Cluster)Roles` [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#escalate-verb) [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#restrictions-on-role-creation-or-update)

```yaml [7-8]
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: escalate
rules:
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["clusterroles", "roles"]
  verbs: ["escalate"]
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Bind verb

Allows creating `(Cluster)RoleBindings` to `(Cluster)Roles` [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#bind-verb)

```yaml [8-12]
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: bind
rules:
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["clusterroles", "roles"]
  verbs: ["bind"]
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Impersonate verb

Verb `impersonate` on `ServiceAccount` allows impersonating [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#impersonate-verb)

```yaml [8-11]
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: impersonate
rules:
- apiGroups: [""]
  resources: ["serviceaccounts"]
  verbs: ["impersonate"]
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Verbs

Wildcard `*` for verb allows `escalate`, `bind` and `impersonate` as well

```yaml [10-11]
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: bind
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
```

<i class="fa-duotone fa-triangle-exclamation"></i> Avoid wildcards whenever possible
