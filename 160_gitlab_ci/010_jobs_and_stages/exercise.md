# Jobs and stages

!!! tip "Goal"
    Learn how to...

    - create jobs
    - organize them in stages
    - understand when jobs in different stages are executed

## Task 1: Create a single job

Add a pipeline to build the code using the following commands:

```bash
apk update
apk add go
go build -o hello .
./hello
```

See the [official documentation about jobs](https://docs.gitlab.com/ee/ci/jobs/index.html).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    1. Add a file called `.gitlab-ci.yml` in the root of the project
    2. Add a job called `build`

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1"
    build:
      script:
      - apk update
      - apk add go
      - go build -o hello .
      - ./hello
    ```

## Task 2: Add a stage

Modify the pipeline to consist of two stages called `check` and `build` where the `check` stage contains the following commands:

```bash
apk update
apk add go
go fmt .
go vet .
```

See the [official documentation about stages](https://docs.gitlab.com/ee/ci/yaml/#stages).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    1. Define two stages using `stages`
    2. Add a job called `check` in the stage `check`

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="1-11"
    stages:
    - check
    - build

    lint:
    stage: check
      script:
      - apk update
      - apk add go
      - go fmt .
      - go vet .

    build:
      stage: build
      script:
      - apk update
      - apk add go
      - go build -o hello .
      - ./hello
    ```

## Task 3: Add parallel jobs

Split the job `check` so that one job called `lint` executes `go fmt .` and another job called `audit` executes `go vet .`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Both jobs `lint` and `audit` must be in the stage `check`.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="5-17"
    stages:
    - check
    - build

    lint:
      stage: check
      script:
      - apk update
      - apk add go
      - go fmt .

    audit:
      stage: check
      script:
      - apk update
      - apk add go
      - go vet .

    build:
      stage: build
      script:
      - apk update
      - apk add go
      - go build -o hello .
      - ./hello
    ```