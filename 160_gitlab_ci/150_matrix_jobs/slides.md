<!-- .slide: id="gitlab_matrix_jobs" class="vertical-center" -->

<i class="fa-duotone fa-cubes-stacked fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Matrix jobs

---

## Matrix jobs

XXX

---

## Hands-On

Cross-compile Go for multiple architectures

1. Extend template to support `GOOS` and `GOARCH`:

    ```yaml
    .build-go:
      parallel:
        matrix:
        - GOOS: linux
          GOARCH: amd64
    ```

1. Update the build command:

    ```yaml
    .build-go:
      script:
      - go build -o hello-${GOOS}-${GOARCH} . \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X main.Author=${AUTHOR}"
    ```

(See new `.gitlab-ci.yml`)
