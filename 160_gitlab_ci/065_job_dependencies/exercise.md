# Job dependencies

!!! tip "Goal"
    Learn how to...

    - XXX

## Task: Start the build job early

XXX start `build` after `audit` without waiting for `lint`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="21-22"
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
      needs:
      - audit
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

This was just a demonstration. The changes will not be preseved in the following chapters.

## Bonus: Start the lint job late

XXX start `lint` after `audit`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="11-12"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.19.2

    lint:
      stage: check
      needs:
      - audit
      script:
      - go fmt .

    audit:
      stage: check
      script:
      - go vet .

    build:
      stage: build
      needs:
      - audit
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

This was just a demonstration. The changes will not be preseved in the following chapters.
