# Registries

!!! tip "Goal"
    Learn how to...

    - authenticate to the GitLab container registry
    - push a container image to the registry

## Task: Push a container image

GitLab include a container registry. In this task you will push a container image to the registry. If the container registry is enabled, GitLab automatically provides predefined variables to access and authenticate to the registry:

- `$CI_REGISTRY`: The registry URL
- `$CI_REGISTRY_IMAGE`: The registry URL with the project name
- `$CI_REGISTRY_USER`: The username to use to push
- `$CI_REGISTRY_PASSWORD`: The password to use to push

Modify the job `package`:

1. Update the build command to use the variables above: `docker build --tag "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}" .`
1. Add the push command directly after the build command: `docker push "${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}"`
1. Login to the registry before building: `docker login -u "${CI_REGISTRY_USER}" -p "${CI_REGISTRY_PASSWORD}" "${CI_REGISTRY}"`
1. Logout from the registry after pushing: `docker logout "${CI_REGISTRY}"`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run. Check the web UI under **Deploy** -> **Container Registry**.

??? info "Hint (Click if you are stuck)"
    Use `before_script` for logging in and `after_script` after logging out.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="114-120"
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
      image: golang:1.23.2

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
      image: alpine
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
    git checkout upstream/160_gitlab_ci/240_registries -- '*'
    ```

<!-- TODO: --password-stdin -->
