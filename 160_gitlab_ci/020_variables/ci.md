<!-- .slide: id="gitlab_ci_variables" -->

## CI variables

XXX

XXX also on group or instance level

### Hands-On

1. Go to **Settings** > **CI/CD** and unfold **Variables**
1. Create variable `AUTHOR` and set to a name of your choice
1. Update build command:

    ```bash
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X main.Author=${AUTHOR}" \
        -o hello \
        .
    ```
