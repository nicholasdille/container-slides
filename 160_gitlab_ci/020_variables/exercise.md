# Variables

!!! tip "Goal"
    Learn how to...

    - add local variable to your pipeline
    - consume pre-defined variables
    - add secrets in the UI

## Task 1: Create a job variable

This exercise requires an updates version of our hello world program:

```bash
git checkout origin/160_gitlab_ci/020_variables/inline -- main.go
```

Add a variable called `version` to the job called `build` and modify the build command as follows:

```bash
go build -o hello -ldflags "-X main.Version=${version}" .
```

See the [official documentation about variables](https://docs.gitlab.com/ee/ci/variables/index.html#define-a-cicd-variable-in-the-gitlab-ciyml-file).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    1. Use the `variable` keyword to define a variable inside the job called `build`
    2. Replace the build command with the one provided above

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="21-22 26-30"
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
      variables:
        version: dev
      script:
      - apk update
      - apk add go
      - |
        go build \
            -ldflags "-X main.Version=${version}" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/020_variables/inline -- '*'

## Task 2: Use a predefined variable

Read the [official documentation about predefined variables](https://docs.gitlab.com/ee/ci/variables/index.html#predefined-cicd-variables) and replace the job variable with the predefined variable `CI_COMMIT_REF_NAME`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    1. Remove the `variable` keyword from the job called `build`
    2. Replace the variable `${version}` with the predefined variable `${CI_COMMIT_REF_NAME}`

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="25-28"
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
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME}" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/020_variables/predefined -- '*'

## Task 3: Add a CI variable in the UI

This exercise requires an updates version of our hello world program:

```bash
git checkout origin/160_gitlab_ci/020_variables/ci -- main.go
```

Read the [official documentation about CI variables](https://docs.gitlab.com/ee/ci/variables/#define-a-cicd-variable-in-the-ui) and extend the build command to provide `main.Author`.

XXX

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint 1 (Click if you are stuck)"
    1. Go to `Settings` > `CI/CD` > `Variables`
    2. Add a variable called `AUTHOR` with your name

??? info "Hint 2 (Click if you are stuck)"
    The `-ldflags` option needs to be extended with `-X 'main.Author=${AUTHOR}'`

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="25-28"
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
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/020_variables/ci -- '*'
