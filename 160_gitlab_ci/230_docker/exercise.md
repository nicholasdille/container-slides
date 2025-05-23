# Docker

!!! tip "Goal"
    Learn how to...

    - build a container image...
    - ...using a service

## Preparation

Building a container image requires a `Dockerfile` which can be fetched with the following command:

```bash
git checkout upstream/160_gitlab_ci/230_docker -- Dockerfile
```

## Task: Build a container image

For building a container image, you will need to...

1. Add a new stage `package` to the pipeline
1. Add a new job `package` to the pipeline
1. Use the image `docker:28.1.1` for the job
1. Add a rule to limit execution to pushes to the default branch
1. Add a service to the job using the image `docker:28.1.1-dind`
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
    - name: docker:28.1.1-dind
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="32 104-115"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
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

    stages:
    - check
    - build
    - test
    - deploy
    - package
    - trigger

    default:
      image: golang:1.24.3

    lint:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go fmt .

    audit:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go vet .

    unit_tests:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .run-on-push-and-in-mr
      - .build-go

    test:
      stage: test
      extends:
      - .run-on-push-and-in-mr
      - .test-go

    deploy:
      stage: deploy
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.13.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello-linux-amd64 \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      stage: deploy
      extends:
      - .run-on-push-to-default-branch
      image: alpine
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public

    package:
      image: docker:28.1.1
      stage: package
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      variables:
        DOCKER_TLS_CERTDIR: ""
      services:
      - docker:28.1.1-dind
      script:
      - docker build --tag hello .

    trigger:
      stage: trigger
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/230_docker -- '*'
    ```

## Bonus task: Create a template for building container images

Similar to the template for building and testing Go, create a template for building container images including logging in and out of a container registry.

<!-- TODO: use !reference -->
<!-- TODO: multi-arch build -->
<!-- TODO: rootless Docker -->
