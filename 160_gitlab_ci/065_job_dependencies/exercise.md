# Job dependencies

We will learn how to stages and job dependencies interact.

!!! tip "Goal"
    Learn how to...

    - ignore stages
    - start jobs as soon as dependencies are met

## Task 1: Start a job early

Use job dependencies to start the job `build` as soon as the job `audit` completes without waiting for other job of the stage `check` to finish. Check out the official documentation of [`needs`](https://docs.gitlab.com/ee/ci/yaml/#needs).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="21-22"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.25.4

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

## Task 2: Start a job late

If two jobs in the same stage should not be executed at the same time, the [`needs`](https://docs.gitlab.com/ee/ci/yaml/#needs) keyword can also delay a job until the dependencies are met. Modify the job `lint` so that it waits for the job `audit` to finish.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="11-12"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.25.4

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

## Task 3: Replace stages with job dependencies

Modify your pipeline:

1. Remove the declaration of `stages` at the top
1. Remove the `stage` field from all jobs
1. Add `needs` to the jobs so that the execution order remains the same

??? info "Hint (Click if you are stuck)"
    The following job dependencies are required:

    1. `build` requires `lint` and `audit`
    1. `test` requires `build`

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="13-15 29-30"
    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    build:
      needs:
      - lint
      - audit
      variables:
        version: $CI_COMMIT_REF_NAME
      script:
      - |
        go build \
            -o hello \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            .
      artifacts:
        paths:
        - hello

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello
    ```
