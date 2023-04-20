## Impersonation using RBAC

(Cluster)Roles can allow impersonation [](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#user-impersonation)

One ServiceAccount can perform actions in the context of a second ServiceAccount

![](120_kubernetes/rbac/impersonation.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

### Use case 1: Delegation of Namespaces

Useful for one cluster used by many teams

Read-only user per namespace

Impersonation to admin per namespace

### Use case 2: Protection from mistakes

Useful for one cluster used by a single team

Cluster-wide read-only user

Impersonation to admin per namespace

---

## Demo: Impersonation

![](120_kubernetes/rbac/demo.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Use case 1

Namespace `test`

Read-only user `test-reader`

Admin user `test-admin`

Usage:

```bash [3]
kubectl \
    --namespace test \
    --as=test-admin \
    run -it --image=alpine --command \
    -- \
    sh
```