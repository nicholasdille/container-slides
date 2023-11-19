# Rules

!!! tip "Goal"
    Learn how to...

    - XXX

## Preparation

XXX

1. XXX `public/`
1. XXX `public/index.html`

## Task 1: Prevent a job from running

XXX https://docs.gitlab.com/ee/ci/yaml/#rules

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

XXX also see GitLab Pages [](https://docs.gitlab.com/ee/user/project/pages/index.html)

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="63-71"
    include:
    - local: go.yaml

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

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

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml --format testname
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
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
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
      script:
      - |
        curl https://dev.seat${SEAT_INDEX}.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      script:
      - cp hello public/
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

## Task 2: Prevent a pipeline from running

XXX https://docs.gitlab.com/ee/ci/yaml/#workflowrules

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="1-11"
    workflow:
      rules:
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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

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

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml --format testname
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
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
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
      script:
      - |
        curl https://dev.seat${SEAT_INDEX}.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      script:
      - cp hello public/
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

## Task 3: Use deploy freeze

XXX https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze

XXX `$CI_DEPLOY_FREEZE`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="3-4"
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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

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

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml --format testname
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
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
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
      script:
      - |
        curl https://dev.seat${SEAT_INDEX}.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      script:
      - cp hello public/
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.
