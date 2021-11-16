## Controller

Responsible for a resource type (kind)

Waits for events for this kind

Makes sure the state toward the description

XXX

---

## Custom Resource (Definition)

Kubernetes offers builtin resource types

Kubernetes can be extended with custom resources

Many controllers ship with a custom resource type (kind)

Custom resource are described in a [Custom Resource Definition (CRD)](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/)

### Example: traefik

Ships with multiple CRDs

XXX

---

## Custom Resource (Definition)

CRDs can have validation since 1.16

CRDs without validation are accepted only before 1.22

CRD API apiextensions.k8s.io/v1beta1 was deprecated and...

...is superceded by apiextensions.k8s.io/v1

Controllers must ship updated CRDs

[API deprecations](https://kubernetes.io/docs/reference/using-api/deprecation-guide/) are documented

---

## Controllers for external services

Controllers can control the state of external services

XXX
