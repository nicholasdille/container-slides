# Unit tests

!!! tip "Goal"
    Learn how to...

    - execute unit tests
    - publish results in GitLab

## Task: Publish unit test results

XXX https://docs.gitlab.com/ee/ci/testing/unit_test_reports.html

The following commands execute unit tests and automatically convert the results to JUnit using [gotestsum](https://github.com/gotestyourself/gotestsum):

```bash
go install gotest.tools/gotestsum@latest
gotestsum --junitfile report.xml
```

XXX https://docs.gitlab.com/ee/ci/yaml/artifacts_reports.html#artifactsreportsjunit

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
    ```yaml linenums="1" hl_lines="22-23"
    stages:
    - check
    - build
    - test

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

    git checkout origin/160_gitlab_ci/090_unit_tests -- '*'