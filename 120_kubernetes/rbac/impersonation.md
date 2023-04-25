## Impersonation using RBAC

(Cluster)Roles can allow impersonation [](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#user-impersonation)

Perform actions in the context of a second ServiceAccount

![](120_kubernetes/rbac/impersonation.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

### Delegation of Namespaces

Useful for one cluster used by many teams

Read-only user per namespace

Impersonation to admin per namespace

### Protection from mistakes

Useful for one cluster used by a single team

Cluster-wide read-only user

Impersonation to admin per namespace

---

## Demo: Impersonation [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/impersonation.demo "impersonation.demo")

![](120_kubernetes/rbac/demo.drawio.svg) <!-- .element: style="float: right; width: 40%;" -->

Demonstrates delegation of namespace

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