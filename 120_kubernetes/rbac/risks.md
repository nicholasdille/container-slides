## RBAC Risks

### Secrets

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#listing-secrets

XXX show secrets

---

## RBAC Risks

### Workflod creation

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#workload-creation

---

## RBAC Risks

### Escalate verb

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#escalate-verb

XXX https://kubernetes.io/docs/reference/access-authn-authz/rbac/#restrictions-on-role-creation-or-update

XXX escalate on (cluster)roles allow changing them

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

XXX https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6

---

## RBAC Risks

### Bind verb

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#bind-verb

XXX bind on (cluster)roles allows creating bindings

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

XXX https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6

---

## RBAC Risks

### Impersonate verb

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#impersonate-verb

XXX impersonate on service accounts allows impersonating

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

XXX https://infosecwriteups.com/the-bind-escalate-and-impersonate-verbs-in-the-kubernetes-cluster-e9635b4fbfc6

---

## RBAC Risks

### Token creation

XXX https://kubernetes.io/docs/concepts/security/rbac-good-practices/#token-request
