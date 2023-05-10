## Writing policies

Cluster-wide and namespaced policies are identical

See later for exceptions

Example:

```yaml
rules:
- name:
  match:
  exclude:
  preconditions:
  validate: | mutate:
```

`applyRules` can be...

- `One` stops after one rules was applied
- `All` processes all rules

---

## Rules

Example:

```yaml
rules:
- match:
    any: | all:
  exclude:
```

`match` what to process...

- Resources, e.g. `Pod` etc.
- Subjects, e.g. `ServiceAccount`, `User` etc.
- (cluster)Roles

Rules are OR'ed when using `any`

Rules are AND'ed when using `all`

Optional `exclude` allows exclusion (similar to `match`)

---

## Preconditions [](https://kyverno.io/docs/writing-policies/preconditions/)

Example:

```yaml
rules:
- preconditions:
```

XXX preconditions

---

## Validate / Mutate

XXX Mutation before validation

---

## ClusterPolicy

validationFailureActionOverrides

.action
.namespaces