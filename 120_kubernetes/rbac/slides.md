## Role-Based Access Control (RBAC)

Control access to resources in a cluster [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

Service accounts represent subjects

(Cluster)Role specifies what to allow on which resources

(Cluster)RoleBinding connects service accounts with (Cluster)Roles

![](120_kubernetes/rbac/rbac.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->

Role and RoleBinding are namespaced

ClusterRole and ClusterRoleBinding are cluster-wide

RoleBindings can reference a ClusterRole which is applied to a namespace

---

## Demo: RBAC [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/rbac.demo "rbac.demo")

Show namespaced permissions

Show cluster-wide permissions

Show mixed permissions

Using `kubectl auth can-i` to check RBAC [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#checking-api-access)

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