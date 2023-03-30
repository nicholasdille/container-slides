<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

Job templates begin with a dot to prevent execution

Templates can be located in the same `.gitlab-ci.yml` (inline)

Templates can be imported using `include` [](https://docs.gitlab.com/ee/ci/yaml/#include) from...

- Files in the same repository
- Files in other repositories of the same instance
- Remote locations (only unauthenticated)

See also the official development guide for templates [](https://docs.gitlab.com/ee/development/cicd/templates.html)

---

## Hands-On: Template and include [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/120_templates/inline "120_templates/inline")

1. Create inline tmplate:

    ```yaml
    .build-go:
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
    ```
    <!-- .element: style="width: 48em;" -->

1. Use in build job

    ```yaml
    build:
      extends: .build-go
      #...
    ```
    <!-- .element: style="width: 48em;" -->

See new `.gitlab-ci.yml`:

```bash
git checkout 160_gitlab_ci/120_templates/inline -- '*'
```

---

## Hands-On: Local [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/120_templates/local "120_templates/local")

1. Add `go.yaml` to root of project
1. Include `go.yaml`:

    ```yaml
    include:
    - local: go.yaml

    build:
      extends: .build-go
      #...
    ```

1. Check pipeline

See new `.gitlab-ci.yml`:

```bash
git checkout 160_gitlab_ci/120_templates/local -- '*'
```

---

## Hands-On: File

1. Create a new project, e.g. `template-go`
1. Move (!) `go.yaml` to the root of the new project
1. In original project, include `go.yaml`:

    ```yaml
    include:
    - project: <GROUP>/template-go
      ref: main
      file: go.yaml
    ```

1. Check pipeline

---

## Pro tip: Multiple inheritence

Jobs can inherit from multiple templates

```yaml
job_name:
  extends:
  - .template1
  - .template2
```

With conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...last writer wins!

```yaml
job_name:
  script: whoami
```

But `variables` are merged!

---

## Pro tip 2: Solve multiple inheritence

Conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...can be resolved by using reference tags [](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#reference-tags)

```yaml
job_name:
  script:
  - !reference[.template1, script]
  - !reference[.template2, script]
```
