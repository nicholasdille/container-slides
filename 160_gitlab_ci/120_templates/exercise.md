# Templates

!!! tip "Goal"
    Learn how to...

    - create templates
    - make jobs reusable
    - load templates from different locations

## Task 1: Create a template inline

Create a template for compiling a go binary from the job `build` and use it in the job `build`. See the official documentation for [templates](https://docs.gitlab.com/ee/development/cicd/templates.html) for guidance.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

    ```yaml
    .build-go:
      script:
      #...
    
    build:
      extends: #...
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

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
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

    You decide whether `artifacts` is part of the template or not!
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout origin/160_gitlab_ci/120_templates/inline -- '*'
    ```

## Task 2: Loading templates from a local file

Move the template into a separate file `go.yaml` and use the [`include`](https://docs.gitlab.com/ee/ci/yaml/#include) keyword to import the template.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    `go.yaml`:

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
    `go.yaml`:

    ```yaml
    .build-go:
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
    ```

    `.gitlab-ci.yml`:

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
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout origin/160_gitlab_ci/120_templates/local -- '*'
    ```

## Task 3: Loading templates from another project

Create a new project anywhere (!), move `go.yaml` there and fix the `include` keyword. See the extended syntax of the [`include`](https://docs.gitlab.com/ee/ci/yaml/#include) keyword to import templates from another project.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

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
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}
    
    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

<!-- TODO: multiple inheritence -->
<!-- TODO: reference tags -->
