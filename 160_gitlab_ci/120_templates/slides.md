<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

Job templates begin with a dot to prevent execution

Templates can be imported using `include` [](https://docs.gitlab.com/ee/ci/yaml/#include) from...

- The same `.gitlab-ci.yml`
- Files in the same repository
- Files in othe repositories of the same instance
- Remote locations

See also the development guide for templates [](https://docs.gitlab.com/ee/development/cicd/templates.html)

---

## Hands-On: Template and include

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

1. Use in build job

    ```yaml
    build:
      extends: .build-go
      # ...
    ```

1. Check pipeline

---

## Hands-On: Local

1. Add `go.yaml` to root of project
1. Include `go.yaml`:

    ```yaml
    include:
    - local: go.yaml

    build:
      extends: .build-go
      # ...
    ```

1. Check pipeline

---

## Hands-On: File

1. Remove `go.yaml` from project
1. Create a new project, e.g. `template-go`
1. Add `go.yaml` to the root of the new project
1. Include `go.yaml`:

    ```yaml
    include:
    - project: <GROUP>/template-go
      ref: main
      file: go.yaml
    ```

1. Check pipeline
