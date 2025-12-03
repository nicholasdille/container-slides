# Services

We will learn how to launch services to in parallel to a single job or all jobs which is very useful for integration tests.

!!! tip "Goal"
    Learn how to...

    - define a service
    - access the service

## Task 1: Create and use a service

Modify the pipeline to include a service and a new job to test it:

1. Create service for the whole pipeline based on the container image `nginx:1.27.5`
1. Add a new job `test-service` to the stage `test` with the following code:
    ```bash
    curl -s http://nginx
    ```
1. Make sure the new job only executes when pushing to `main`

See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#services).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    The service is defined globally in the `gitlab-ci.yml` using the keyword `services`:

    ```yaml
    services:
    - nginx:1.27.5
    ```

??? example "Solution (Click if you are stuck)"
    `gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="30-37"
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

    services:
    - nginx:1.27.5

    test-service:
      extends:
      - .run-on-push-to-default-branch
      script:
      - curl -s http://nginx

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
    git checkout upstream/160_gitlab_ci/220_services -- '*'
    ```

## Task 2: Move the service into the job

If the service is only required in a single job, it can be moved into the job.

Move the service into the job `test-service`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="33-34"
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

    test-service:
      extends:
      - .run-on-push-to-default-branch
      services:
      - nginx:1.27.5
      script:
      - curl -s http://nginx

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

This was just a demonstration. The changes will not be preserved in the following chapters.
