<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Matrix jobs

---

## Matrix jobs

Matrix jobs execute the same script with different inputs

Defined using `parallel` [](https://docs.gitlab.com/ee/ci/yaml/#parallel)

Inputs are specified using environment variables

The `matrix` keyword under `parallel` defines variables sets

Matrix variables can be used for...

- Script blocks
- Runner tags
- Image

---

## Hands-On 1/ [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/150_matrix_jobs "150_matrix_jobs")

Cross-compile Go for multiple architectures

1. Extend template to support `GOOS` and `GOARCH`:

    ```yaml
    .build-go:
      #...
      parallel:
        matrix:
        - GOOS: linux
          GOARCH: amd64
        - GOOS: linux
          GOARCH: arm64
      script:
      - go build -o hello-${GOOS}-${GOARCH} . \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'"
    ```
    <!-- .element: style="width: 47em;" -->

---

## Hands-On 2/2 [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/150_matrix_jobs "150_matrix_jobs")

2. Update the test job:

    ```yaml
    test:
      #...
      script:
      - ./hello-linux-amd64
    ```
    <!-- .element: style="width: 30em;" -->

1. Check pipeline

See new `.gitlab-ci.yml`:

```bash
git checkout 150_matrix_jobs
```
