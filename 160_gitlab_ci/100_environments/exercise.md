# Environments

!!! tip "Goal"
    Learn how to...

    - XXX

## Preparation

XXX

1. Retrieve passwords for dev and live environments from the info page
1. Create unprotected but masked CI variable `PASS` twice with scope `dev` and `live`
1. Create unprotected CI variable `SEAT_INDEX` with your seat number

## Task 1: Add target environment

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

XXX https://dev.seatN.inmylab.de/hello

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="5 48-61"
    stages:
    - check
    - build
    - test
    - deploy

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
    ```

## Task 2: Add deployment to development environment

XXX branch `dev`

XXX then changes

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

XXX https://dev.seatN.inmylab.de/hello

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="51 57"
    stages:
    - check
    - build
    - test
    - deploy

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
        name: ${CI_COMMIT_REF_NAME}
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
      script:
      - |
        curl https://${CI_COMMIT_REF_NAME}.seat${SEAT_INDEX}.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat:${PASS}
    ```

This was just a demonstration. The changes will not be preseved in the following chapters.

## Task 3: Add deployment to production environment

XXX branch `live`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

XXX https://live.seatN.inmylab.de/hello

??? info "Hint (Click if you are stuck)"
    XXX

XXX Warning to return to branch main
