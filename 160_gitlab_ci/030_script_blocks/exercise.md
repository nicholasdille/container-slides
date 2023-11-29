# Scriptblocks

!!! tip "Goal"
    Learn how to...

    - Use `before_script` and `after_script`
    - Separate preparation and cleanup commands from core functionality

## Task: Separate script blocks into preparation and main task

Commands are currently specified using the `script` directive. These commands consist of preparation, core functionality and (possibly) cleanup.

To improve readability, move the preparation of the execution environment to a `before_script`. See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#before_script).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Move calls to `apk` to the `before_script`.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="7-9 15-17 23-25"
    stages:
    - check
    - build

    lint:
      stage: check
      before_script:
      - apk update
      - apk add go
      script:
      - go fmt .

    audit:
      stage: check
      before_script:
      - apk update
      - apk add go
      script:
      - go vet .

    build:
      stage: build
      before_script:
      - apk update
      - apk add go
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/030_script_blocks -- '*'

Cleanup commands can be move to `after_script` ([official documentation](https://docs.gitlab.com/ee/ci/yaml/#after_script)) but we have no use for this in the current example.

## Bonus 1: When `after_script` is executed

Add commands to all three script block `before_script`, `script` and `after_script`. Test two scenarios:

1. The pipeline succeeds
1. The pipeline failes

What happens to the code in `after_script`?

??? example "Solution (Click to reveal)"
    Command in `after_script` are always executed even if the job fails.

    This can be very useful for cleaning up.

## Bonus 2: What happens to environment variables in script blocks?

Define environment variables in all three script blocks and display them in the same and in the following script block.

When are environment variables available?

??? example "Solution (Click to reveal)"
    Commands in `before_script` and `script` share a shell session. Environment variables are available throughout these script blocks.

    Commands in `after_script` are executed in a new shell session. Environment variables defined in `before_script` and `script` are gone.