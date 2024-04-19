## Role-Based Access Control (RBAC)

## (Cluster)Role(Binding) <i class="fa fa-face-smile-wink"></i>

Role(Binding) only exist in one namespace

ClusterRole(Binding) apply to the entire cluster

### ClusterRole(Binding)

The rights apply in all namespaces

### ClusterRole with RoleBinding

This enables the reuse of roles

The role is available in the entire cluster

The rights apply in the namespace of the RoleBinding

![](120_kubernetes/rbac/rbac.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->

---

## Demo: RBAC [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/rbac.demo "rbac.demo")

Show namespaced permissions

Show cluster-wide permissions

Show mixed permissions

Using `kubectl auth can-i` to check RBAC [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access)

Demonstrate [rakkess](https://github.com/corneliusweig/rakkess) [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/rakkess.demo "rakkess.demo")

---

## How to write roles

(Cluster)Roles require verbs and resources

### How to find resources

```bash
kubectl api-resources
```

### How to find verbs

Accepted verbs [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb): Create, get, list, watch, update, patch, delete

Find supported verbs for resources:

```bash
kubectl api-resources --output wide
```

### Subresources

Some resources have subresources, e.g. `pods/exec`

No known solution to find verbs for subresources

---

## How to specify subjects

Subjects [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects) are referenced in (Cluster)RoleBindings

### ServiceAccount

Can be created: `kubectl create sa <name>`

Token authentication maps to service accounts

Internally referenced by<br/>`system:serviceaccount:<namespace>:<name>`

### User / Group

Authentication backends can add users and groups

Certificate authentication maps to users