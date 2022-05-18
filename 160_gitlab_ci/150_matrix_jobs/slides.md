<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Matrix jobs

---

## Matrix jobs

Matrix jobs execute the same script with different inputs

Matrix jobs are defined using `parallel` [](https://docs.gitlab.com/ee/ci/yaml/#parallel)

The `matrix` keyword under `parallel` defines variables sets

---

## Hands-On 1/

Cross-compile Go for multiple architectures

1. Extend template to support `GOOS` and `GOARCH`:

    ```yaml
    .build-go:
      # ...
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

---

## Hands-On 2/2

2. Update the test job:

    ```yaml
    test:
      #...
      script:
      - ./hello-linux-amd64
    ```

1. Check pipeline

(See new `.gitlab-ci.yml`)
