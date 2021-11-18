## Controller

Responsible for a resource type

Waits for events for this kind

Converges the state toward the description

### Custom Resource (Definition)

Builtin resource types, e.g. `Pod`

Custom resources to extend Kubernetes

Many controllers ship with a custom resource type

Custom resource are described in a [Custom Resource Definition (CRD)](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)

---

## Custom Resource (Definition)

Can have validation since 1.16

Accepted without validation only before 1.22

`apiextensions.k8s.io/v1beta1` was deprecated and...

...is superceded by `apiextensions.k8s.io/v1`

Controllers must ship updated CRDs

[API deprecations](https://kubernetes.io/docs/reference/using-api/deprecation-guide/) are documented

...and can be discovered using:

- [pluto](https://github.com/FairwindsOps/Pluto) (CLI)
- [deprek8](https://github.com/naquada/deprek8) (rego policy)

---

## Demo: Controller

Quick and dirty

Written in bash (yes, that is possible)

### Idea

CRD for controlling replicas

```yaml
apiVersion: k8s.dille.io/v1
kind: ReplicaConfig
metadata:
  name: nginx
spec:
  kind: Deployment
  name: nginx
  replicas: 3
```

---

## Controllers for external services

Controllers can control the state of external services

Custom resource describes that desired state

Controller synchronized this state

The external service is updated when the custom resource is...

...created

...modified

...removed

Enables infrastructure management from Kubernetes
