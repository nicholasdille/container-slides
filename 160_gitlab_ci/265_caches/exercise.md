# Caches

!!! tip "Goal"
    Learn how to...

    - define caches
    - store data in a cache
    - restore data from a cache
    - avoid relying on the cache

## Task 1: Test caching

The [cache](https://docs.gitlab.com/ee/ci/caching/) is used by adding the keyword [`cache`](https://docs.gitlab.com/ee/ci/yaml/index.html#cache) in a pipeline job, a job template or in the `default` section. Let's give it a try:

1. Add a job `test_cache` to the first stage
1. Download dependency information from the uniget project:
    ```bash
    curl -sSLfO https://github.com/uniget-org/cli/raw/main/go.mod
    curl -sSLfO https://github.com/uniget-org/cli/raw/main/go.sum
    ```
1. Use the [official example for Go](https://docs.gitlab.com/ee/ci/caching/#cache-go-dependencies) to enable caching
1. Instead of `go test` run `go mod download` to download dependencies only

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run. Retry the job to see the effect of the cache.

??? info "Hint (Click if you are stuck)"
    Use the `.go-cache` job template from the official example for Go.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci-yml`:

    ```yaml
    #...

    .go-cache:
      variables:
        GOPATH: $CI_PROJECT_DIR/.go
      before_script:
      - mkdir -p .go
      cache:
        key: ${CI_PROJECT_PATH_SLUG}
        policy: pull-push
        paths:
        - .go/pkg/mod/

    test_cache:
      stage: check
      extends:
      - .go-cache
      script:
      - go mod download  

    #...
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

## Task 2: Add caching

Now, integrate the job template `.go-cache` into the pipeline and use it for the jobs `build` and `unit_test`.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml linenums="1" hl_lines="9-18 23"
    .go-targets:
      parallel:
        matrix:
        - GOOS: linux
          GOARCH: amd64
        - GOOS: linux
          GOARCH: arm64
    
    .go-cache:
      variables:
        GOPATH: $CI_PROJECT_DIR/.go
      before_script:
      - mkdir -p .go
      cache:
        key: ${CI_PROJECT_PATH_SLUG}
        policy: pull-push
        paths:
        - .go/pkg/mod/
    
    .build-go:
      extends:
      - .go-targets
      - .go-cache
      script:
      - |
        go build \
            -o hello-${GOOS}-${GOARCH} \
            -ldflags "-X main.Version=${CI_COMMIT_REF_NAME} -X 'main.Author=${AUTHOR}'" \
            .
      artifacts:
        paths:
        - hello-${GOOS}-${GOARCH}
    
    .test-go:
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file hello-${GOOS}-${GOARCH}
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/265_caches -- '*'
    ```