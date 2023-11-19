# Images

!!! tip "Goal"
    Learn how to...

    - specify which container image to use for a job
    - XXX

## Task: Simplify using container images

In the previous exampes, we called `apk` at the beginning of every job to install Go. This had to be repeated for every job because Go was not present. Choosing an image for a job using the `image` directive, time is saved by avoiding commands to install required tools. See the [official documentation](https://docs.gitlab.com/ee/ci/yaml/#image).

Replace the calls to `apk` with the container image `golang:1.19.2`.

XXX version bump for `golang` image

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    - Remove `before_script`
    - Add `image: golang:1.19.2` instead

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="7 13 19"
    stages:
    - check
    - build

    lint:
      stage: check
      image: golang:1.19.2
      script:
      - go fmt .

    audit:
      stage: check
      image: golang:1.19.2
      script:
      - go vet .

    build:
      stage: build
      image: golang:1.19.2
      script:
      - |
        go build \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            -o hello \
            .
      - ./hello
    ```
    
    If you want to jump to the solution, execute the following command:

    git checkout origin/160_gitlab_ci/040_image -- '*'

## Bonus: Test different images

Add a job to your pipeline to test different container images. Check how different images offer specialized execution environments:

1. Use `python:3` and test running `python --version`
1. Use `node` and test running `node --version`
