# Releases

!!! tip "Goal"
    Learn how to...

    - create a release on GitLab
    - use the GitLab `release-cli`

## Task: Create a release

GitLab can create [releases](https://docs.gitlab.com/ee/user/project/releases/index.html) based on a Git tag. The release can contain a description and links to assets. The assets must be stored elsewhere.

1. Check out the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#release) about the `release` keyword
1. Modify the job `pages` to create a release in addition to the script block
1. The release should be based on the current commit hash (`$CI_COMMIT_SHA`)
1. Use the unique pipeline ID (`$CI_PIPELINE_IID`) as the tag name
1. Set an arbitrary name and description

For the `release` keyword to work, the `release-cli` binary must be present in the execution environment of the job:

1. Set `image` to `registry.gitlab.com/gitlab-org/release-cli:v0.14.0`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Your release should look similar to this:

    ```yaml
    release:
      tag_name: ${CI_PIPELINE_IID}
      name: Release ${CI_PIPELINE_IID}
      description: |
        Some multi
        line text
      ref: ${CI_COMMIT_SHA}
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="97-104"
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
    git checkout upstream/160_gitlab_ci/250_releases -- '*'
    ```

<!-- TODO: create the release when a tag is created -->
