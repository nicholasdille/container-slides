# Unit tests

!!! tip "Goal"
    Learn how to...

    - execute unit tests
    - publish results in GitLab

This exercise adds a unit test to the hello world application.

## Preparation

Let's update the code:

```bash
git checkout upstream/160_gitlab_ci/090_unit_tests -- main_test.go go.mod go.sum
```

## Task: Publish unit test results

The following commands execute unit tests and automatically convert the results to JUnit using [gotestsum](https://github.com/gotestyourself/gotestsum):

```bash
go install gotest.tools/gotestsum@latest
gotestsum --junitfile report.xml
```

See the official documentation for [special artifacts and specifically reports](https://docs.gitlab.com/ee/ci/yaml/artifacts_reports.html#artifactsreportsjunit).

Add a job `unit_test` to the stage `check` containing the above commands. The job needs to define a special artifact from the file `report.xml` so that GitLab recognizes it as as JUnit XML report.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run which shows the unit test results on the tab in the overview.

??? info "Hint (Click if you are stuck)"
    GitLab has published an [example](https://docs.gitlab.com/ee/ci/testing/unit_test_report_examples.html#go). The unit test report is published using a special type of artifact:

    ```yaml linenums="1" hl_lines="6-7"
    build:
      stage: test
      script: echo
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="19-27"
    stages:
    - check
    - build
    - test

    default:
      image: golang:1.24.3

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
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/090_unit_tests -- '*'
    ```
