# Renovate

!!! tip "Goal"
    Learn how to...

    - discover dependencies used in your code and pipeline
    - get update proposals for outdated dependencies

We will be using [Renovate](https://github.com/renovatebot/renovate) to discover and update dependencies.

## Task: Add Renovate to your pipeline

The easiest way to get Renovate on GitLab is to integrated it into your pipeline:

1. Create a new project access token `renovate` with role `Developer` and scopes `api`, `read_repository`, `read_registry`
1. Add project access token `renovate` to CI variable `RENOVATE_TOKEN`
1. Add a job `renovate` to the stage `check`
1. Limit execution to a) scheduled pipelines and b) if the variable `$RENOVATE` is set
1. Use the image `renovate/renovate`
1. Set the variable `LOG_LEVEL` to `debug`
1. Use the following script to execute Renovate:
    ```bash
    renovate --platform gitlab \
        --endpoint ${CI_API_V4_URL} \
        --token ${RENOVATE_TOKEN} \
        ${CI_PROJECT_PATH}
    ```
1. Create a scheduled pipeline and define a variable `RENOVATE` with the value `true`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="38-49"
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

    stages:
    - check
    - build
    - test
    - deploy
    - package
    - trigger

    default:
      image: golang:1.19.2

    renovate:
      stage: check
      rules:
      - if: '$CI_PIPELINE_SOURCE == "schedule" && $RENOVATE'
      image: renovate/renovate
      variables:
        LOG_LEVEL: debug
      script: |
        renovate --platform gitlab \
            --endpoint ${CI_API_V4_URL} \
            --token ${CI_JOB_TOKEN} \
            --autodiscover true

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
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
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
      image: registry.gitlab.com/gitlab-org/release-cli:v0.14.0
      release:
        tag_name: ${CI_PIPELINE_IID}
        name: Release ${CI_PIPELINE_IID}
        description: |
          Some multi
          line text
        ref: ${CI_COMMIT_SHA}
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public

    package:
      image: docker:20.10.18
      stage: package
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:20.10.18-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      variables:
        DOCKER_HOST: tcp://docker:2375
      before_script:
      - docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" "${CI_REGISTRY}"
      script:
      - docker build --tag "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}" .
      - docker push "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}"
      after_script:
      - docker logout "${CI_REGISTRY}"

    trigger:
      stage: trigger
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/270_renovate -- '*'
    ```
