## How to write roles 1/

(Cluster)Roles require verbs and (sub)resources

```yaml [6-7]
#...
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### How to find resources

Find supported resources:

```bash
kubectl api-resources
```

--

```plaintext
NAME                      APIVERSION                    NAMESPACED  KIND
configmaps                v1                            true        ConfigMap
endpoints                 v1                            true        Endpoints
namespaces                v1                            false       Namespace
nodes                     v1                            false       Node
persistentvolumeclaims    v1                            true        PersistentVolumeClaim
persistentvolumes         v1                            false       PersistentVolume
pods                      v1                            true        Pod
secrets                   v1                            true        Secret
serviceaccounts           v1                            true        ServiceAccount
services                  v1                            true        Service
daemonsets                apps/v1                       true        DaemonSet
deployments               apps/v1                       true        Deployment
replicasets               apps/v1                       true        ReplicaSet
statefulsets              apps/v1                       true        StatefulSet
horizontalpodautoscalers  autoscaling/v2                true        HorizontalPodAutoscaler
cronjobs                  batch/v1                      true        CronJob
jobs                      batch/v1                      true        Job
endpointslices            discovery.k8s.io/v1           true        EndpointSlice
ingresses                 networking.k8s.io/v1          true        Ingress
poddisruptionbudgets      policy/v1                     true        PodDisruptionBudget
clusterrolebindings       rbac.authorization.k8s.io/v1  false       ClusterRoleBinding
clusterroles              rbac.authorization.k8s.io/v1  false       ClusterRole
rolebindings              rbac.authorization.k8s.io/v1  true        RoleBinding
roles                     rbac.authorization.k8s.io/v1  true        Role
```

---

## How to write roles 2/

(Cluster)Roles require verbs and (sub)resources

```yaml [6-7]
#...
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

### How to find verbs

Accepted verbs [](https://kubernetes.io/docs/reference/access-authn-authz/authorization/#determine-the-request-verb): Create, get, list, watch, update, patch, delete

Find supported verbs for resources:

```bash
kubectl api-resources --output wide
```

--

```plaintext
NAME               ...  VERBS
bindings           ...  create
componentstatuses  ...  get,list
configmaps         ...  create,delete,deletecollection,get,list,patch,update,watch
endpoints          ...  create,delete,deletecollection,get,list,patch,update,watch
events             ...  create,delete,deletecollection,get,list,patch,update,watch
limitranges        ...  create,delete,deletecollection,get,list,patch,update,watch
namespaces         ...  create,delete,get,list,patch,update,watch
nodes              ...  create,delete,deletecollection,get,list,patch,update,watch
```

---

## How to write roles 3/3

(Cluster)Roles require verbs and (sub)resources

```yaml
- apiGroups: [""]
  resources: ["pods/portforward"]
  verbs: ["get", "list", "create"]
```

### Subresources

Some resources have subresources, e.g. `pods/portforward`

```bash
kubectl get --raw / | jq -r '.paths[]' | grep -E "^/apis?/" \
| while read -r API; do
    echo "=== ${API}"
    kubectl get --raw "${API}" \
    | jq -r 'select(.resources != null) | .resources[].name'
done
```

--

```plaintext
=== /api/v1
namespaces/finalize
namespaces/status
nodes/proxy
nodes/status
persistentvolumeclaims/status
persistentvolumes/status
pods/attach
pods/binding
pods/ephemeralcontainers
pods/eviction
pods/exec
pods/log
pods/portforward
pods/proxy
pods/status
replicationcontrollers/scale
replicationcontrollers/status
resourcequotas/status
serviceaccounts/token
services/proxy
services/status
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

OIDC maps to users and groups

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
  verbs: ["get", "update"]
```
