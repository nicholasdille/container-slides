# Scriptblocks

!!! tip "Goal"
    Learn how to...

    - XXX

## Task: Separate script blocks into preparation and main task

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="7-9 15-17 23-25"
    stages:
    - check
    - build

    lint:
      stage: check
      before_script:
      - apk update
      - apk add go
      script:
      - go fmt .

    audit:
      stage: check
      before_script:
      - apk update
      - apk add go
      script:
      - go vet .

    build:
      stage: build
      before_script:
      - apk update
      - apk add go
      script:
      - |
          go build \
              -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
              -o hello \
              .
      - ./hello
    ```
