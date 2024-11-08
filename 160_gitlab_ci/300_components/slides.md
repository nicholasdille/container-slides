<!-- .slide: id="gitlab_components" class="vertical-center" -->

<i class="fa-duotone fa-box-open-full fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Components

---

## Components

Components [](https://docs.gitlab.com/ee/ci/components/) are a new way to offer reusable jobs

They are similar to job templates...

...but more contained, i.e. they cannot be overwritten

### Authoring

Directory layout for component `foo`:
- Either: `templates/go.yml`
- Or: `templates/go/template.yml`

`template.yml` requires a header with `spec` [](https://docs.gitlab.com/ee/ci/yaml/#spec) and body:

```yaml
spec:
  input:
    path:
      type: string
      description: "Path to the source code"
---
job:
  script: go build $[[ inputs.path ]]
```

The body can also contain job templates

---

## Components vs. Templates

Both are reusable

### Anatomy

Templates are fragments of a job

Components are self-contained jobs

### XXX

Templates can be overwridden

Components cannot

### Parameters

Templates require variables

Components define inputs

### Versioning

XXX

---

### Catalog

XXX https://docs.gitlab.com/ee/ci/components/#cicd-catalog

XXX toggle to catalog project

---

### Best practices

XXX https://docs.gitlab.com/ee/ci/components/#cicd-component-security-best-practices
