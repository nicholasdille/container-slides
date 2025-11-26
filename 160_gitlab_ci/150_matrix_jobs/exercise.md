# Matrix Jobs

!!! tip "Goal"
    Learn how to...

    - run the same `script` for different inputs

## Preparation

Switch back to the branch `main`.

## Task 1: Build binary for multiple platforms

Build the `hello` binary for multiple target platform. Matrix jobs enable you to reuse the existing code and parameterize it using different inputs.

Improve the template `.build-go` in `go.yaml` to build for `linux/amd64` and `linux/arm64`:

1. Check the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#parallel) for `parallel` to create a matrix job
1. Add one input for `GOOS=linux` and `GOARCH=amd64`
1. Add another input for `GOOS=linux` and `GOARCH=arm64`
1. Modify the build command to write to separate files using `hello-${GOOS}-${GOARCH}`
1. Move the artifact definition into the template and include all `hello` binaries
1. Fix the smoke test to execute the `hello` binary for `linux/amd64`
1. Fix the job `deploy` to upload the `hello` binary for `linux/amd64`
1. Fix the job `pages` to copy the `hello` binary for `linux/amd64`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Matrix pipelines require the `parallel:matrix` keyword.

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml linenums="1" hl_lines="2-7 12 16 19-24 30"
    .build-go:
      parallel:
        matrix:
        - GOOS: linux
          GOARCH: amd64
        - GOOS: linux
          GOARCH: arm64
      script:
      - |
        go build \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            -o hello-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - hello-${GOOS}-${GOARCH}

    .unit-tests-go:
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="79 90"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never

    include:
    - local: go.yaml

    .run-on-push-to-default-branch:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'

    .run-on-push-and-in-mr:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

    default:
      image: golang:1.25.4

    lint:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go fmt .

    audit:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go vet .

    unit_tests:
      extends:
      - .run-on-push-and-in-mr
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .run-on-push-and-in-mr
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      extends:
      - .run-on-push-and-in-mr
      - .test-go

    deploy:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello-linux-amd64 \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      needs:
      - build
      - unit_tests
      extends:
      - .run-on-push-to-default-branch
      image: alpine
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public

    trigger:
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/150_matrix_jobs_demo1 -- '*'
    ```

## Task 2: Test an alternative to specify the same inputs

Test whether the following syntax for the inputs produces the same results in a pipeline:

```yaml
.build-go:
  parallel:
    matrix:
    - GOOS: linux
      GOARCH: [ amd64, arm64 ]
```

## Bonus task: Check binaries for correct platform

Add another matrix job to check the target platform of the `hello` binaries:

1. Add another template called `.test-go` to `go.yaml` defining a matrix job using the same inputs as for `.build-go`
1. In the new template run `file hello-${GOOS}-${GOARCH}` to display the target platform
1. Modify the job `test` to use the new template

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml linenums="1" hl_lines="1-7 10-11 22-30"
    .go-targets:
      parallel:
        matrix:
        - GOOS: linux
          GOARCH: amd64
        - GOOS: linux
          GOARCH: arm64

    .build-go:
      extends:
      - .go-targets
      script:
      - |
        go build \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            -o hello-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - hello-${GOOS}-${GOARCH}

    .test-go:
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file hello-${GOOS}-${GOARCH}

    .unit-tests-go:
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="63"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never
      
    include:
    - local: go.yaml

    .run-on-push-to-default-branch:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'

    .run-on-push-and-in-mr:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

    default:
      image: golang:1.25.4

    lint:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go fmt .

    audit:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go vet .

    unit_tests:
      extends:
      - .run-on-push-and-in-mr
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .run-on-push-and-in-mr
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      extends:
      - .run-on-push-and-in-mr
      - .test-go

    deploy:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello-linux-amd64 \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      needs:
      - build
      - unit_tests
      extends:
      - .run-on-push-to-default-branch
      image: alpine
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public

    trigger:
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/150_matrix_jobs_demo2 -- '*'
    ```