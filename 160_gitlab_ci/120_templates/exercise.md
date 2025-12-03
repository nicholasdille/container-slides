# Templates

We will convert the jobs for testing and building the example application into templates and explore where templates can be stored.

!!! tip "Goal"
    Learn how to...

    - create templates
    - make jobs reusable
    - load templates from different locations

## Task 1: Create a template inline

Create a template for compiling a go binary from the job `build`. Then use it in the job `build`. Afterwards, do the same for the job `unit_tests`.

Refer to the slides and see the official documentation for [templates](https://docs.gitlab.com/ee/development/cicd/templates.html) for guidance.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml
    .build-go:
      script:
      #...
    
    build:
      extends: #...
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="28-37 44-45"
    include:
    - local: go.yaml

    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    .unit-tests-go:
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

    unit_tests:
      extends:
      - .unit-tests-go

    .build-go:
      script:
      - |
        go build \
            -o hello \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            .
      artifacts:
        paths:
        - hello

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello

    deploy:
      needs:
      - build
      - unit_tests
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    trigger:
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/120_templates/inline -- '*'
    ```

## Task 2: Loading templates from a local file

Move the templates into a separate file `go.yaml` and use the [`include`](https://docs.gitlab.com/ee/ci/yaml/#include) keyword to import the template from a local file.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Create the file `go.yaml` and move the template there. Use the [`include:local`](https://docs.gitlab.com/ci/yaml/#includelocal) keyword to import the template.

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml
    .build-go:
      script:
      - |
        go build \
            -o hello \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            .
      artifacts:
        paths:
        - hello

    .unit-tests-go:
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
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
      image: golang:1.25.4

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
      - gotestsum --junitfile report.xml
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
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
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
    git checkout upstream/160_gitlab_ci/120_templates/local -- '*'
    ```

## Task 3: Loading templates from another project

Create a new project, move `go.yaml` to the root of the new project and update the `include` keyword. See the extended syntax of the [`include`](https://docs.gitlab.com/ee/ci/yaml/#include) keyword to import templates from another project.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Use the [`include:project`](https://docs.gitlab.com/ci/yaml/#includeproject) keyword to import the template from the other project.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="1-4"
    include:
    - project: seatN/template-go
      ref: main
      file: go.yaml

    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    unit_tests:
      extends:
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello

    deploy:
      needs:
      - build
      - unit_tests
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    trigger:
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.
