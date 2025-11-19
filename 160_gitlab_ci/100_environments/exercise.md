# Environments

!!! tip "Goal"
    Learn how to...

    - use environments to specify deployment targets
    - select environments dynamically

## Preparation

Create CI variables for use in the following exercises:

1. Create two environments called `dev` and `live` in the GitLab UI. No other settings are required
1. Retrieve passwords for dev and live environments from the info page
1. Create unprotected but masked CI variable `PASS` twice with scope `dev` and `live`
1. Create unprotected CI variable `SEAT_INDEX` with your seat number

## Task 1: Add target environment

Add a new stage `deploy` with a job called `deploy`. Use the following commands and add an environment to the job in order to upload the binary to the dev environment:

```bash
curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
    --fail \
    --verbose \
    --upload-file hello \
    --user seat${SEAT_INDEX}:${PASS}
```

Mind that `curl` is not available in the default image `golang:1.25.3`. You can use `curlimages/curl:8.17.0`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run and be able to download the `hello` binary from `https://seatN.dev.webdav.inmylab.de/hello`.

??? info "Hint (Click if you are stuck)"
    Install `curl` in a `before_script` to separate the preparation from the core steps:

    ```yaml
    job_name:
      image: curlimages/curl:8.17.0
    ```

    Now place the `curl` command under `script`.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="5 48-61"
    stages:
    - check
    - build
    - test
    - deploy

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

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

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

    deploy:
      stage: deploy
      environment:
        name: dev
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/100_environments/demo1 -- '*'
    ```

## Task 2: Add deployment to development environment

Create a new branch `dev` from the branch `main` and modify the job `deploy` to use the environment from the pre-defined variable `$CI_COMMIT_REF_NAME`. Mind that the upload URL is also using a hard-coded environment name.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="51 57"
    stages:
    - check
    - build
    - test
    - deploy

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

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

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

    deploy:
      stage: deploy
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/100_environments/demo2 -- '*'
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.

## Task 3: Add deployment to production environment

Create the branch `live` from the branch `dev` and push it without further changes.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run and be able to download the `hello` binary from `https://seatN.live.webdav.inmylab.de/hello`.

!!! info "Heads up"
    Checkout the branch `main` to make sure that the following exercises are based on the correct code base.
