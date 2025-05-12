<!-- .slide: id="gitlab_components" class="vertical-center" -->

<i class="fa-duotone fa-box-open-full fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## CI/CD Components

---

## CI/CD Components

<i class="fa-duotone fa-solid fa-4x fa-sparkles"></i> <!-- .element: style="float: right;" -->

Components [](https://docs.gitlab.com/ee/ci/components/) are a new way to offer reusable jobs

They are similar to job templates...

...but more contained, i.e. they cannot be overwritten

### Usage

Include a component using `include:component` [](https://docs.gitlab.com/ee/ci/yaml/#includecomponent)

The component must reside on the same server as the project

The path must be fully qualified

```yaml
include:
- component: $CI_SERVER_FQDN/my-org/my-project/my-component@1.0
```

---

### Authoring

Directory layout for component called `go`:
- Either: `templates/go.yml`
- Or: `templates/go/template.yml`

Components require a header with `spec` [](https://docs.gitlab.com/ee/ci/yaml/#spec) and body:

  ```yaml
  spec:
    inputs:
      path:
        type: string
        description: "Path to the source code"
  ---
  job:
    script: go build $[[ inputs.path ]]
  ```

The body can also contain job templates

---

## Components vs. Templates 1/2

<i class="fa-duotone fa-solid fa-4x fa-scale-balanced"></i> <!-- .element: style="float: right;" -->

Both are reusable

### Anatomy

Templates are fragments of a job

Components are self-contained jobs

### Composability

Templates can be overridden

Components require inputs declarations

---

## Components vs. Templates 2/2

<i class="fa-duotone fa-solid fa-4x fa-scale-balanced"></i> <!-- .element: style="float: right;" -->

Both are reusable

### Parameters

Templates require variables

Components define inputs

### Versioning

Templates require a special syntax for `include`

Components must be digest/version pinned

---

### CI/CD Catalog

<i class="fa-duotone fa-solid fa-4x fa-book-sparkles"></i> <!-- .element: style="float: right;" -->

CI/CD Catalog [](https://docs.gitlab.com/ee/ci/components/#cicd-catalog) is a collection of components

Instance-wide catalog

Components can be used without the catalog

Project owners can switch to catalog project [](https://docs.gitlab.com/ee/ci/components/#set-a-component-project-as-a-catalog-project)

---

## Hands-On

See chapter [CI/CD Components](/hands-on/2024-11-21/300_components/exercise/)
