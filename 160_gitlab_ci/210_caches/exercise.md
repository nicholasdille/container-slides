# Caches

!!! tip "Goal"
    Learn how to...

    - define caches
    - store data in a cache
    - restore data from a cache
    - avoid relying on the cache

## Task 1: XXX

XXX https://docs.gitlab.com/ee/ci/yaml/index.html#cache

XXX https://docs.gitlab.com/ee/ci/caching/

XXX fetch go.mod (https://github.com/uniget-org/cli/raw/main/go.mod)

XXX fetch go.sum (https://github.com/uniget-org/cli/raw/main/go.sum)

XXX new job `test_cache` for testing

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

XXX retry

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml
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

    #...

    .build-go:
      extends:
      - .go-cache
      #...

    #...
    ```

    `.gitlab-ci-yml`:

    ```yaml
    #...

    build:
      extends:
      - .build-go
      #...

    test:
      extends:
      - .go-cache
      #...

    #...
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

## Task 2: XXX

XXX remove job `test_cache`

XXX integrate into jobs `build` and `test`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    `go.yaml`:

    ```yaml
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

    #...

    .build-go:
      extends:
      - .go-cache
      #...

    #...
    ```

    `.gitlab-ci-yml`:

    ```yaml
    #...

    build:
      extends:
      - .build-go
      #...

    test:
      extends:
      - .go-cache
      #...

    #...
    ```
