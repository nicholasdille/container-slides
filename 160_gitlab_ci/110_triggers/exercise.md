# Triggers

!!! tip "Goal"
    Learn how to...

    - trigger pipelines in other projects
    - learn about upstream and downstream pipelines
    - use trigger tokens
    - use multi-project pipelines
    - use parent-child pipelines

!!! info "Heads up"
    Checkout the branch `main` to make sure that the following exercises are based on the correct code base.

## Preparation

Triggering another pipeline requires a seconds project:

1. Create a new project, e.g. a private project called `trigger`
1. Add `.gitlab-ci.yml` with the following content to the root of new project:
    ```yaml
    test:
      script:
      - printenv
    ```

## Task 1: Using a trigger token

The trigger token allows pipelines to be triggered using the API. Let's give this a try!

In the web UI:

1. In the second project, go to **Settings** > **CI/CD** and unfold **Pipeline trigger tokens**
1. Create a trigger token and copy the token as well as the `curl` snippet
1. Go back to `demo` project
1. Create an unprotected but masked CI variable called `TOKEN`

In your pipeline:

1. Add new stage `trigger` as well as a job `trigger`
1. Add `curl` snippet in `script` block
1. Replace `TOKEN` with the variable `$TOKEN`
1. Replace `REF_NAME` with branch name (`main`)

Afterwards check the pipeline in both projects in the GitLab UI. You should see successful pipeline runs.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="6 64-72"
    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

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
            --user seat${SEAT_INDEX}:${PASS}

    trigger:
      stage: trigger
      script: |
        curl https://gitlab.inmylab.de/api/v4/projects/seat${SEAT_INDEX}%2ftrigger/trigger/pipeline \
            --request POST \
            --silent \
            --fail \
            -F "token=${TOKEN}" \
            -F "ref=main"
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/110_triggers/curl -- '*'
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

## Task 2: Using a multi-project pipeline

The second option for triggering a pipeline in another project, are multi-project pipelines. They come with a handy syntax in `gitlab-ci.yaml` by using the [`trigger`](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger) keyword.

Update the job called `trigger` from the previous task by replacing the `script` and using the `trigger` keyword. The value of the `trigger` keyword should be the path to the project you want to trigger.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run and be able to expand the downstream pipeline to see the jobs and their status.

??? info "Hint (Click if you are stuck)"
    Replace the `script` keyword with the `trigger` keyword.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="64-66"
    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

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
            --user seat${SEAT_INDEX}:${PASS}

    trigger:
      stage: trigger
      trigger: <path-to-project>
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

## Task 3: Using a parent-child pipeline

A parent-child pipeline executes a downstream pipeline from a YAML file. Modify the contents of the `trigger` keyword to use [`include`](https://docs.gitlab.com/ee/ci/pipelines/parent_child_pipelines.html) to execute a pipeline with the same content as in the first task but - this time - from a local file `child.yaml`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run and be able to expand the downstream pipeline to see the jobs and their status.

??? info "Hint (Click if you are stuck)"
    Create the file `child.yaml` with the following pipeline:

    ```yaml
    test:
      script:
      - printenv
    ```

    Use `trigger` > `include` to call the pipeline from this file.

??? example "Solution (Click if you are stuck)"
    `child.yaml`:
    
    ```yaml
    test:
      script:
      - printenv
    ```

    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="67"
    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

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
            --user seat${SEAT_INDEX}:${PASS}

    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/110_triggers/parent-child -- '*'
    ```

<!-- TODO: variable inheritence -->
<!-- TODO: dynamic child pipelines -->
<!-- TODO: pull artifact from upstream pipeline -->
