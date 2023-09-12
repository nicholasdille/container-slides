# Jobs and stages

!!! important "Goal"
    Learn how to...
    - create jobs
    - organize them in stages

## Introduction

XXX **bold**

XXX _italic_

``` mermaid
graph LR
  A[Start] --> B{Error?};
  B -->|Yes| C[Hmm...];
  C --> D[Debug];
  D --> B;
  B ---->|No| E[Yay!];
```

!!! info "Hints"
    - X
    - Y

## Preparation

XXX

## Task: Create a single job

Add a pipeline to build the code using the following commands:

```bash
apk update
apk add go
go build -o hello .
./hello
```

??? example "Hint (Click if you are stuck)"
    1. Add a file called `.gitlab-ci.yml` in the root of the project
    2. Add a job called `build`

??? example "Solution (Click if you are stuck)"
    ```yaml
    ---8<--- "010_jobs_and_stages/build/.gitlab-ci.yml"
    ```

## Task: Add a stage

Modify the pipeline to consist of two stages called `check` and `build` where the `check` stage contains the following commands:

```bash
apk update
apk add go
go fmt .
go vet .
```

??? example "Hint (Click if you are stuck)"
    1. Define two stages using `stages`
    2. Add a job called `check` in the stage `check`

??? example "Solution (Click if you are stuck)"
    ```yaml
    ---8<--- "010_jobs_and_stages/lint/.gitlab-ci.yml"
    ```

## Task: Add parallel jobs

Split the job `check` so that one job called `lint` executes `go fmt .` and another job called `audit` executes `go vet .`.

??? example "Hint (Click if you are stuck)"
    Both jobs `lint` and `audit` must be in the stage `check`.

??? example "Solution (Click if you are stuck)"
    ```yaml
    ---8<--- "010_jobs_and_stages/parallel/.gitlab-ci.yml"
    ```
