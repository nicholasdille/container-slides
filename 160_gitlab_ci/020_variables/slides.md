<!-- .slide: id="gitlab_variables" class="vertical-center" -->

<i class="fa-duotone fa-square-root-variable fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Variables

---

## Favors

Variables can be...

- defined in the pipeline definition
- predefined by GitLab
- defined in the UI

XXX explore them

### Hands-On

1. Update files from `src/`
1. `variables` in definition:

    ```yaml
    build:
      stage: build
      variables:
        version: dev
      script:
      - apk update
      - apk add go
      - |
        go build \
          -ldflags "-X main.Version=${version}" \
          -o hello \
          .
    ```
