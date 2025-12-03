# Jobs and stages

We will create the first pipeline.

!!! tip "Goal"
    Learn how to...

    - create jobs
    - organize them in stages
    - understand when jobs in different stages are executed

## Preparation

This workshop is based on an example hello world application written in Go. Get the code using the following command:

```bash
git checkout upstream/160_gitlab_ci/example_app -- '*'
```

## Task 1: Create a single job

Create a pipeline to build the example application using the following commands:

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
    `.gitlab-ci.yml`:

    ```yaml linenums="1"
    build:
      script:
      - apk update
      - apk add go
      - go build -o hello .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/010_jobs_and_stages/build -- '*'
    ```

## Task 2: Add a stage

Improve the pipeline to consist of two stages called `check` and `build` where the `check` stage contains a job called `check` with the following commands:

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
    `.gitlab-ci.yml`:

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
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/010_jobs_and_stages/lint -- '*'
    ```

## Task 3: Add parallel jobs

Split the job `check` so that one job called `lint` executes `go fmt .` and another job called `audit` executes `go vet .`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Both jobs `lint` and `audit` must be in the stage `check`.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
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
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/010_jobs_and_stages/parallel -- '*'
    ```
