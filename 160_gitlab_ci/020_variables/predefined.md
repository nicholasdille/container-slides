<!-- .slide: id="gitlab_predefined_variables" -->

## Predefined variables

XXX

### Hands-On

1. Update build command:

    ```bash
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME}" \
        -o hello \
        .
    ```
