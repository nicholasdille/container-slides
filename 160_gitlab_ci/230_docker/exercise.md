# Docker

We will build a container image and use a service for this.

!!! tip "Goal"
    Learn how to...

    - build a container image
    - use a service to run the Docker daemon

## Preparation

Building a container image requires a `Dockerfile` which can be fetched with the following command:

```bash
git checkout upstream/160_gitlab_ci/230_docker -- Dockerfile
```

## Task: Build a container image

For building a container image, you will need to...

1. Add a new job `package` to the pipeline which requires the jobs `build` and `unit_tests`
1. Use the image `docker:29.0.4` for the job
1. Add a rule to limit execution to pushes to the default branch
1. Add a service to the job using the image `docker:29.0.4-dind`
1. Add a variable `DOCKER_TLS_CERTDIR` to the job and set it to an empty string
1. Execute the command `docker build --tag hello .`

!!! tip "Heads-Up"
    The GitLab runner must be configured to run services in privileged mode so that the Docker daemon is able to start.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    The service should be set to:

    ```yaml
    variables:
      DOCKER_TLS_CERTDIR: ""
    services:
    - name: docker:29.0.4-dind
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="95-107"
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

    package:
      needs:
      - build
      - unit_tests
      image: docker:29.0.4
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:29.0.4-dind
      variables:
        DOCKER_TLS_CERTDIR: ""
      script:
      - docker build --tag hello .

    trigger:
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/230_docker -- '*'
    ```
