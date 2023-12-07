# Services

!!! tip "Goal"
    Learn how to...

    - define a service
    - access the service

## Task 1: Create and use a service

Service are launched in parallel to the regular job to add missing functionality, e.g. a database backend to execute integration tests. See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#services) and modify the pipeline:

1. Create service for the whole pipeline based on the container image `nginx:1.20.2`
1. Add a new job `test-service` to the stage `test` with the following code:
    ```bash
    curl -s http://nginx
    ```
1. Make sure the new job only executes when pushing to `main`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    The service is defined globally in the `gitlab-ci.yml` using the keyword `services`:

    ```yaml
    services:
    - nginx:1.20.2
    ```

??? example "Solution (Click if you are stuck)"
    `gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="37-38 78-83"
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
    - trigger

    default:
      image: golang:1.19.2

    services:
    - nginx:1.20.2

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

    test-service:
      stage: test
      extends:
      - .run-on-push-to-default-branch
      script:
      - curl -s http://nginx

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
      image: alpine
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public

    trigger:
      stage: trigger
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/220_services -- '*'
    ```

## Task 2: Move the service into the job

The above task forced a second container to be created for every job although only one job has used the service. Optimize resource usage by moving the service into the job `test-service`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="67-68"
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
    - trigger
    
    default:
      image: golang:1.19.2
    
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
    
    test-service:
      stage: test
      extends:
      - .run-on-push-to-default-branch
      services:
      - nginx:1.20.2
      script:
      - curl -s http://nginx
    
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
      image: alpine
      script:
      - cp hello-linux-amd64 public/hello
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.
