# Images

!!! tip "Goal"
    Learn how to...

    - XXX

## Task: Simplify using container images

XXX

XXX version bump for `golang` image

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="7 13 19"
    stages:
    - check
    - build

    lint:
      stage: check
      image: golang:1.19.2
      script:
      - go fmt .

    audit:
      stage: check
      image: golang:1.19.2
      script:
      - go vet .

    build:
      stage: build
      image: golang:1.19.2
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      - ./hello
    ```
