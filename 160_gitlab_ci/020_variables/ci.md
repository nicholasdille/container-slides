<!-- .slide: id="gitlab_ci_variables" -->

## CI variables

Stored securely in the GitLab server

Injected into jobs at runtime

Available in project-, group- and instance-level

Careful with protected variables

---

## Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/020_variables/ci "020_variables/ci")

1. Go to **Settings** > **CI/CD** and unfold **Variables**
1. Create unprotected variable `AUTHOR` and set to a value of your choice
1. Update build command and add `AUTHOR`:

    ```bash
    build:
      script: |
      - go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} 
                      -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
    ```
    <!-- .element: style="width: 47em;" -->

1. Fetch change:

    ```bash
    git checkout 020_variables/ci
    ```
    <!-- .element: style="width: 47em;" -->

---

## Pro tip: Protect masked variables

Prevent project maintainers/owners to read masked CI variables:

1. Define variable in parent group
2. Limit permissions to group

### Still security by obscurity

But masked values can always be leaked through a pipeline:

```yaml
job_name:
  script:
  - echo "${MASKED_VAR}" | base64
```
