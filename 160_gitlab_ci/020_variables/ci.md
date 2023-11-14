<!-- .slide: id="gitlab_ci_variables" -->

## CI variables

Stored securely in the GitLab server

Injected into jobs at runtime

Available in project-, group- and instance-level

Careful with protected variables

Loops are detected, e.g. `FOO=$BAR` and `BAR=$FOO`

---

## Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/020_variables/ci "020_variables/ci")

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
    git checkout origin/160_gitlab_ci/020_variables/ci -- '*'
    ```
    <!-- .element: style="width: 47em;" -->

---

## Pro tip: Masked variables for all values

Many values are rejected by GitLab

Store base64-encoded values

Decode values before use:

```yaml
job_name:
  script:
  - echo "$( echo "${MASKED_VAR}" | base64 -d )"
```

Careful! Original value will not be masked!

---

## Pro tip 2: Protect masked variables

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
