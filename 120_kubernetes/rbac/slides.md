## Role-Based Access Control (RBAC)

Method of regulating access

Based on roles of individual users

### Kubernetes

Roles are made of permissions for resources

Roles are defined ...
- in a namespace using resource `Role`
- for the whole cluster using resource `ClusterRole`

Roles are applied ...
- in a namespace using resource `RoleBinding`
- for the whole cluster using resource `ClusterRoleBinding`

Subjects are mostly service accounts

---

## Role-Based Access Control (RBAC)

### In one namespace

`Role` defines permissions for the namespace

`RoleBinding` assigns the role to a subject

### For the whole cluster

`ClusterRole` defines permissions

`ClusterRoleBinding` assigns the role to a subject

![](120_kubernetes/rbac/rbac.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->

---

## Role-Based Access Control (RBAC)

### Mix and match

`ClusterRole` can be used in `RoleBinding`

This enables the reuse of cluster-wide roles

The role is available in the entire cluster

The rights apply in the namespace of the RoleBinding

Useful for pre-defined roles by a platform team

![](120_kubernetes/rbac/rbac2.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->

---

## Demo: RBAC [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/rbac.demo "rbac.demo")

Show namespaced permissions

Show cluster-wide permissions

Show mixed permissions

Using `kubectl auth can-i` to check RBAC [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access)

Demonstrate [rakkess](https://github.com/corneliusweig/rakkess) [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/rakkess.demo "rakkess.demo")
