# CI/CD Components

!!! tip "Goal"
    Learn how to...

    - Create a component
    - Add inputs to a component
    - Use a component locally

!!! tip "Hints"
    [Official documentation]() for CI/CD Components

## Task 1: Create a component

Create a component in the same repository:

1. Add a new directory called `templates`
1. Add a new file called `templates/go.yml`
1. Add `spec` in the header
1. Add inputs called `binary-name` and `needs`

??? info "Hint (Click if you are stuck)"
    - The file *must* have the extension `.yml` (not `.yaml`)
    - The file *must* be located in the directory `templates`
    - The header and body of a component *must* be separated by a line containing only `---`

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml
    spec:
      inputs:
        binary-name:
          default: hello
        needs:
          type: array
          default: []
    ---
    ```

## Task 2: Add inputs to the component

Now fill the body of the component with the job templates for Go in `go.yaml`:

1. Copy all job templates from `go.yaml` to the body of `templates/go.yml`
1. Unhide the jobs `.build-go` and `.test-go` and `.unit-tests-go`
1. Use the input for `needs` in the `build-go` job
1. Add an `image` field to `build-go` and `test-go` with a value of `golang:1.25.3`
1. Remove `go.yaml`

??? info "Hint (Click if you are stuck)"
    - The header and body of a component *must* be separated by a line containing only `---`
    - Unhide a job by removing the leading dot

??? info "Hint (Click if you are stuck)"
    The syntax for using the input for `needs` is: `needs: $[[ inputs.needs ]]`

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml linenums="1" hl_lines="1-8 30 39 43 55"
    spec:
      inputs:
        binary-name:
          default: hello
        needs:
          type: array
          default: []
    ---

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

    build-go:
      needs: $[[ inputs.needs ]]
      extends:
      - .go-targets
      - .go-cache
      image: golang:1.25.3
      script:
      - |
        go build \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            -o $[[ inputs.binary-name ]]-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    test-go:
      needs:
      - build-go
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    unit-tests-go:
      extends:
      - .go-cache
      image: golang:1.25.3
      script:
      - go install gotest.tools/gotestsum@latest
      - ./.go/bin/gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

## Task 3: Use component locally

The component is now ready to be used:

1. Add an `include` for the component
1. Set the inputs `build-stage` and `test-stage` to `build` and `test` respectively
1. Remove the jobs `build` and `test` from `.gitlab-ci.yml`

??? info "Hint (Click if you are stuck)"
    - Check out the [documentation of `include` for components](https://docs.gitlab.com/ee/ci/yaml/#includecomponent)
    - Unhide a job by removing the leading dot

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml
    #...
    include:
    - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/go@$CI_COMMIT_SHA
      inputs:
        binary-name: hello
        needs: []
    #...
    ```

## Task 4: Add input for image

Customize the template to make the image configurable:

1. Add an input called `image` to the component
1. Set the default value of `image` to `golang:1.25.3`
1. Use the input `image` for the `image` field in the `build-go` and `unit-tests-go` jobs
1. (Optionally) Add a value for `image` to the include in `.gitlab-ci.yml`

??? info "Hint (Click if you are stuck)"
    The syntax for using an input in a component is `$[[ inputs.<name> ]]`

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml linenums="1" hl_lines="5-6 31-32 39 65"
    spec:
      inputs:
        binary-name:
          default: hello
        image: 
          default: golang:1.25.3
        needs:
          type: array
          default: []
    ---

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

    .go-image:
      image: $[[ inputs.image ]]

    build-go:
      needs: $[[ inputs.needs ]]
      extends:
      - .go-targets
      - .go-cache
      - .go-image
      script:
      - |
        go build \
            -ldflags "-X main.Version=${version} -X 'main.Author=${AUTHOR}'" \
            -o $[[ inputs.binary-name ]]-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    test-go:
      needs:
      - build-go
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    unit-tests-go:
      extends:
      - .go-cache
      - .go-image
      script:
      - go install gotest.tools/gotestsum@latest
      - ./.go/bin/gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:

    ```yaml
    #...
    include:
    - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/go@$CI_COMMIT_SHA
      inputs:
        binary-name: hello
        image: golang:1.25.3
        needs: []
    #...
    ```

## Task 5: Add input for version and author

Continue to customize the component by making the author name as well as the version configurable:

1. Add an input called `author` to the component
1. Replace the variable for the author with the input `author` in the `build-go` job
1. Add an input called `version` to the component
1. Replace the variable for the version with the input `version` in the `build-go` job

??? info "Hint (Click if you are stuck)"
    Replace the variables `${AUTHOR}` and `${version}` with the inputs `$[[ inputs.author ]]` and `$[[ inputs.version ]]`.

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml linenums="1" hl_lines="5-8 47"
    spec:
      inputs:
        binary-name:
          default: hello
        author:
          default: unknown
        version:
          default: dev
        image: 
          default: golang:1.25.3
        needs:
          type: array
          default: []
    ---

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

    .go-image:
      image: $[[ inputs.image ]]

    build-go:
      needs: $[[ inputs.needs ]]
      extends:
      - .go-targets
      - .go-cache
      - .go-image
      script:
      - |
        go build \
            -ldflags "-X main.Version=$[[ inputs.version ]] -X 'main.Author=$[[ inputs.author ]]'" \
            -o $[[ inputs.binary-name ]]-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    test-go:
      needs:
      - build-go
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    unit-tests-go:
      extends:
      - .go-cache
      - .go-image
      script:
      - go install gotest.tools/gotestsum@latest
      - ./.go/bin/gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:

    ```yaml
    #...
    include:
    - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/go@$CI_COMMIT_SHA
      inputs:
        binary-name: hello
        author: ${AUTHOR}
        version: ${CI_COMMIT_REF_NAME}
        image: golang:1.25.3
        needs: []
    #...
    ```

## Task 6: Name prefix

Components import whole jobs into a pipeline which can cause name conflicts. To avoid this issue, add a prefix to the job names:

1. Add an input called `name-prefix` to the component
1. Use the input `name-prefix` to prefix the job names in the component
1. Add a value for `name-prefix` to the include in `.gitlab-ci.yml`

??? info "Hint (Click if you are stuck)"
    Inputs can be used anywhere - even in job names.

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml linenums="1" hl_lines="14-15 40 56 58 68"
    spec:
      inputs:
        binary-name:
          default: hello
        author:
          default: unknown
        version:
          default: dev
        image: 
          default: golang:1.25.3
        needs:
          type: array
          default: []
        name-prefix:
          default: "foo"
    ---

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

    .go-image:
      image: $[[ inputs.image ]]

    $[[ inputs.name-prefix]]-build-go:
      needs: $[[ inputs.needs ]]
      extends:
      - .go-targets
      - .go-cache
      - .go-image
      script:
      - |
        go build \
            -ldflags "-X main.Version=$[[ inputs.version ]] -X 'main.Author=$[[ inputs.author ]]'" \
            -o $[[ inputs.binary-name ]]-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    $[[ inputs.name-prefix]]-test-go:
      needs:
      - $[[ inputs.name-prefix]]-build-go
      extends:
      - .go-targets
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    $[[ inputs.name-prefix]]-unit-tests-go:
      extends:
      - .go-cache
      - .go-image
      script:
      - go install gotest.tools/gotestsum@latest
      - ./.go/bin/gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:

    ```yaml
    #...
    include:
    - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/go@$CI_COMMIT_SHA
      inputs:
        binary-name: hello
        author: ${AUTHOR}
        version: ${CI_COMMIT_REF_NAME}
        image: golang:1.25.3
        needs: []
        name-prefix: hello
    ```

## Task 7: Add array input for rules

The components has only used string inputs so far. To configure rules for the jobs of a component, an array input is needed:

1. Add an input called `rules` to the component
1. Set the type of the new input to `array`
1. Use the input `rules` for the `rules` field in the `build-go` and `test-go` jobs
1. Add a value for `rules` in the include and copy the rules from the job template `.run-on-push-and-in-mr` to 

??? info "Hint (Click if you are stuck)"
    Input types are documented [here](https://docs.gitlab.com/ee/ci/yaml/#specinputstype).

??? example "Solution (Click if you are stuck)"
    `templates/go.yml`:

    ```yaml linenums="1" hl_lines="14-15 49 65"
    spec:
      inputs:
        binary-name:
          default: hello
        author:
          default: unknown
        version:
          default: dev
        image: 
          default: golang:1.25.3
        needs:
          type: array
          default: []
        rules:
          type: array
          default: []
        name-prefix:
          default: "foo"
    ---

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

    .go-image:
      image: $[[ inputs.image ]]

    $[[ inputs.name-prefix]]-build-go:
      needs: $[[ inputs.needs ]]
      extends:
      - .go-targets
      - .go-cache
      - .go-image
      rules: $[[ inputs.rules ]]
      script:
      - |
        go build \
            -ldflags "-X main.Version=$[[ inputs.version ]] -X 'main.Author=$[[ inputs.author ]]'" \
            -o $[[ inputs.binary-name ]]-${GOOS}-${GOARCH} \
            .
      artifacts:
        paths:
        - $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    $[[ inputs.name-prefix]]-test-go:
      needs:
      - $[[ inputs.name-prefix]]-build-go
      extends:
      - .go-targets
      rules: $[[ inputs.rules ]]
      before_script:
      - apt-get update
      - apt-get -y install file
      script:
      - |
        file $[[ inputs.binary-name ]]-${GOOS}-${GOARCH}

    $[[ inputs.name-prefix]]-unit-tests-go:
      extends:
      - .go-cache
      - .go-image
      rules: $[[ inputs.rules ]]
      script:
      - go install gotest.tools/gotestsum@latest
      - ./.go/bin/gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml
    ```

    `.gitlab-ci.yml`:

    ```yaml
    #...
    include:
    - component: $CI_SERVER_FQDN/$CI_PROJECT_PATH/go@$CI_COMMIT_SHA
      inputs:
        binary-name: hello
        author: ${AUTHOR}
        version: ${CI_COMMIT_REF_NAME}
        image: golang:1.25.3
        needs: []
        rules:
        - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
        - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
        name-prefix: hello
    #...
    ```

If you want to jump to the solution, execute the following command:

```bash
git checkout upstream/160_gitlab_ci/300_components -- '*'
```

## Bonus task 1: Move the component to a separate project

Using a separate project for a component is the prerequisite to use it in the CI/project Catalog:

1. Create a new project
1. Copy the directory `templates` to the new project
1. Push the changes to the new project
1. Create a release in the new project

You can also add a `.gitlab-ci.yml` to the new project to test the component.

## Bonus task 2: Add the component to the CI/CD Catalog

Toggle the project to be a [catalog project](https://docs.gitlab.com/ee/ci/components/#set-a-component-project-as-a-catalog-project).

## Bonus task 3: Add inputs for GOOS and GOARCH

Make the variables `GOOS` and `GOARCH` from the job `.go-targets` configurable by adding an input.
