<!-- .slide: id="gitlab_ci_variables" -->

## CI variables

Stored securely in the GitLab server

Injected into jobs at runtime

Available in project-, group- and instance-level

Careful with protected variables

### Hands-On

1. Go to **Settings** > **CI/CD** and unfold **Variables**
1. Create unprotected variable `AUTHOR` and set to a value of your choice
1. Update build command:

    ```bash
    go build \
        -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
        -o hello \
        .
    ```
    <!-- .element: style="width: 45em;" -->
