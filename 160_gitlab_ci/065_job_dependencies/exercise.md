# Job dependencies

!!! tip "Goal"
    Learn how to...

    - ignore stages
    - start jobs as soon as dependencies are met

## Task: Start a job early

Start the job `build` as soon as the job `audit` completes without waiting for other job of the stage `check` to finish. Check out the official documentation of [`needs`](https://docs.gitlab.com/ee/ci/yaml/#needs).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="21-22"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.25.3

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

This was just a demonstration. The changes will not be preserved in the following chapters.

## Bonus task: Start a job late

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
      image: golang:1.25.3

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

This was just a demonstration. The changes will not be preserved in the following chapters.

<!-- TODO: Convert stages to needs -->
