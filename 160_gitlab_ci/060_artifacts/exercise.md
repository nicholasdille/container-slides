# Artifacts

!!! tip "Goal"
    Learn how to...

    - XXX

## Task: XXX

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="4 27-35"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.19.2

    lint:
      stage: check
      script:
      - go fmt .

    audit:
      stage: check
      script:
      - go vet .

    build:
      stage: build
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      artifacts:
        paths:
        - hello

    test:
      stage: test
      image: alpine
      script:
      - ./hello
    ```
