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

---

## How to write roles 1/

(Cluster)Roles require verbs and (sub)resources

### How to find resources

Find supported resources:

```bash
kubectl api-resources
```

---

## How to write roles 2/

(Cluster)Roles require verbs and (sub)resources

### How to find verbs

Accepted verbs [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb): Create, get, list, watch, update, patch, delete

Find supported verbs for resources:

```bash
kubectl api-resources --output wide
```

---

## How to write roles 3/3

(Cluster)Roles require verbs and (sub)resources

### Subresources

Some resources have subresources, e.g. `pods/exec`

Find supported verbs for subresources:

```bash
kubectl get --raw / | jq --raw-output '.paths[]' | grep "^/apis/" \
| while read -r API; do
    echo "=== ${API}"
    kubectl get --raw "${API}" \
    | jq --raw-output 'select(.resources != null) | .resources[].name'
done
```

---

## How to specify subjects

Subjects [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#referring-to-subjects) are referenced in (Cluster)RoleBindings

### ServiceAccount

Can be created: `kubectl create sa <name>`

Token authentication maps to service accounts

Internally referenced by `system:serviceaccount:<ns>:<name>`

### User / Group

Authentication backends can add users and groups

Certificate authentication maps to users

---

## How to specify resource names

Limit access to specific resources using `resourceNames`

```yaml [9]
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: configmap-updater
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["my-configmap"]
  verbs: ["update", "get"]
```

---

## Convenience subcommands in `kubectl`

Create resources from the command line
- `kubectl create role` [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-create-role)
- `kubectl create clusterrole` [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-create-clusterrole)
- `kubectl create rolebinding` [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-create-rolebinding)
- `kubectl create clusterrolebinding` [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-create-clusterrolebinding)

### Apply resources from a file

`kubectl auth reconcile` [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#kubectl-auth-reconcile)

Creates and updates RBAC ... including referenced namespaces

Full sync with `--remove-extra-permissions` and `--remove-extra-subjects`

Use `--dry-run=client` to investigate changes
