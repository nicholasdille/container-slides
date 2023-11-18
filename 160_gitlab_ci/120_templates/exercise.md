# Templates

!!! tip "Goal"
    Learn how to...

    - XXX

## Task 1: Create a template inline

XXX https://docs.gitlab.com/ee/ci/yaml/#include

XXX https://docs.gitlab.com/ee/development/cicd/templates.html

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="31-37 41-42"
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

    .build-go:
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .

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
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

## Task 2: Loading templates from a local file

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX `go.yaml`

    ```yaml
    .build-go:
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
    ```

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="1-2"
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
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

## Task 3: Loading templates from another project

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="1-4"
    include:
    - project: seat/template-go
      ref: main
      file: go.yaml

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
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.
