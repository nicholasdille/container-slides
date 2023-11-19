# Defaults

!!! tip "Goal"
    Learn how to...

    - Avoid repetition in jobs
    - Specify defaults are the top of your pipeline

## Task: Don't repeat yourself

All jobs currently have a dedicated `image` directive. Using defaults, this repetition can be avoided. See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#default).

Replace job specific `image` directives with the `default` directive.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    1. Remove `image` from all build jobs
    1. Add `default` with the `image` directive at the top

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="5-6"
    stages:
    - check
    - build

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

    build:
      stage: build
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/050_default -- '*'

## Bonus 1: Override defaults

Jobs can still choose to use an image different from the default:

1. Add a new job
1. Add an `image` directory to the new job
1. Specify a different image
1. Check out how the executation environment changes

## Bonus 2: Default values for variables

XXX `variables` outside `default`
