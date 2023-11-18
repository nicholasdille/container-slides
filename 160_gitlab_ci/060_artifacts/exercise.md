# Artifacts

!!! tip "Goal"
    Learn how to...

    - define artifacts
    - consume artifacts

## Task 1: Pass an artifact to the next stage

Artifacts are useful for splitting a task in separate job. Refer to the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#artifacts).

Improve the pipeline by using artifacts:

1. Create an artifact from the `hello` binary
1. Create a new stage called `test` with a job called `test`
1. Call the `hello` binary as a smoke test

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Example for creating an artifacts:

    ```yaml
    job_name:
      script:
      - echo foo >file.txt
      artifacts:
        paths:
        - file.txt
    ```

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

## Bonus 1: Define from which jobs to receive artifacts

Usually, artifacts are received from all job in the previous stages. Decide from which jobs to receive artifacts using the `dependencies` directive. See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#dependencies).

XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="34-35"
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
      dependencies:
      - build
      script:
      - ./hello
    ```

## Bonus 2: Passing environment variables

XXX https://docs.gitlab.com/ee/ci/variables/index.html#pass-an-environment-variable-to-another-job

??? info "Hint (Click if you are stuck)"
    Example for creating an artifact for environment variables:

    ```yaml
    job_name:
      script:
      - echo "foo=bar" >build.env
      artifacts:
        reports:
          dotenv: build.env
    ```

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="21-22 27 29 33-34 40"
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
      variables:
        BINARY_NAME: hello
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o "${BINARY_NAME}" \
            .
      - echo "${BINARY_NAME}" >build.env
      artifacts:
        paths:
        - hello
        reports:
          dotenv: build.env

    test:
      stage: test
      image: alpine
      script:
      - ./${BINARY_NAME}
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.
