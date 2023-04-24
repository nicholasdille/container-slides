## Role-Based Access Control (RBAC)

Control access to resources in a cluster [](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

Service accounts represent subjects

(Cluster)Role specifies what to allow on which resources

(Cluster)RoleBinding connects service accounts with (Cluster)Roles

![](120_kubernetes/rbac/rbac.drawio.svg) <!-- .element: style="width: 65%; margin-top: 0.5em; margin-bottom: 0.5em;" -->

Role and RoleBinding are namespaced

ClusterRole and ClusterRoleBinding are cluster-wide

RoleBindings can reference a ClusteRole which is applied to a namespace

---

## Demo: RBAC

XXX