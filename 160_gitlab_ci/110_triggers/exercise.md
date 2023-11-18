# Triggers

!!! tip "Goal"
    Learn how to...

    - XXX

## Preparation

XXX

1. Create a new project (anywhere!)
1. Add `.gitlab-ci.yml` with the following content to root of new project:
    ```yaml
    test:
      script:
      - printenv
    ```

## Task 1: Using a trigger token

XXX

1. In second project, go to **Settings** > **CI/CD** and unfold **Pipeline triggers**
1. Create a trigger and copy token as well as `curl` snippet
1. Go back to first project
1. Store `TOKEN` as unprotected but masked CI variable [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_ci_variable)
1. Add new stage and job called `trigger`
1. Add `curl` snippet in `script` block
1. Fill in `REF_NAME` with branch name (`main`)

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="6 64-67"
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
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
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

    trigger:
      stage: trigger
      script:
      - XXX
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.

## Task 2: Using a multi-project pipeline

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="64-67"
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
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
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
    
    trigger:
      stage: trigger
      trigger:
        XXX
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.

## Task 3: Using a parent-child pipeline

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="22-23"
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
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
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
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```
