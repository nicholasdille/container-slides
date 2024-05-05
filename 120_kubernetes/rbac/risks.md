## RBAC Risks

### Secrets

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#listing-secrets

XXX show secrets

---

## RBAC Risks

### Workload creation

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#workload-creation

---

## RBAC Risks

### Escalate verb

Verb `escalate` on (Cluster)Role allows changing it [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#escalate-verb) [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#restrictions-on-role-creation-or-update)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: escalate
rules:
- apiGroups:
  - "rbac.authorization.k8s.io"
  resources:
  - clusterroles
  - roles
  verbs:
  - escalate
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Bind verb

Verb `bind` on (Cluster)Roles allows creating (Cluster)RoleBindings [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#bind-verb)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: bind
rules:
- apiGroups:
  - "rbac.authorization.k8s.io"
  resources:
  - clusterroles
  - roles
  verbs:
  - bind
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Impersonate verb

Verb `impersonate` on service accounts allows impersonating [](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#impersonate-verb)

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: impersonate
rules:
- apiGroups:
  - ""
  resources:
  - serviceaccounts
  verbs:
  - impersonate
```

Full example [](https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6)

---

## RBAC Risks

### Token creation

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#token-request
