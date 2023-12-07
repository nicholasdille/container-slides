# Security

!!! tip "Goal"
    Learn how to...

    - detect secrets in your code
    - detect vulnerabilities in your code

## Task: Add integrated security scans

GitLab offers multiple security scanners in the community edition:

1. Checkout the [official documentation](https://docs.gitlab.com/ee/user/application_security/secret_detection/index.html) for secret detection and integrate it into your pipeline
1. Checkout the [official documentation](https://docs.gitlab.com/ee/user/application_security/sast/index.html) for static application security testing and integrate it into your pipeline
1. Checkout the [official documentation](https://docs.gitlab.com/ee/user/application_security/container_scanning/index.html) for container scanning and integrate it into your pipeline

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    The following templates are available for the above features:

    - Secret detection: `Security/Secret-Detection.gitlab-ci.yml`
    - Static application security testing: `Security/SAST.gitlab-ci.yml`
    - Container scanning: `Security/Container-Scanning.gitlab-ci.yml`

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="17-23"
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
    - template: Security/Secret-Detection.gitlab-ci.yml
    - template: Security/SAST.gitlab-ci.yml
    - template: Security/Container-Scanning.gitlab-ci.yml

    container_scanning:
      variables:
        CS_DEFAULT_BRANCH_IMAGE: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}

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
            ${CI_PROJECT_PATH}

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
    git checkout origin/160_gitlab_ci/280_security -- '*'
    ```

!!! tip "Heads-Up"
    You can also [select a different scanner for container scanning](https://docs.gitlab.com/ee/user/application_security/container_scanning/index.html#change-scanners) using the variable `$CS_ANALYZER_IMAGE`. The following values are available:

    | Scanner         | Image                                                            |
    |-----------------|------------------------------------------------------------------|
    | Default (trivy) | registry.gitlab.com/security-products/container-scanning:6       |
    | Grype           | registry.gitlab.com/security-products/container-scanning/grype:6 |
    | Trivy           | registry.gitlab.com/security-products/container-scanning/trivy:6 |
