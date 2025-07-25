# CI/CD Steps

!!! tip "Goal"
    Learn how to...

    - Create a step
    - Add inputs to a step
    - Use a step locally

!!! tip "Hints"
    [Official documentation](https://docs.gitlab.com/ee/ci/steps/) for CI/CD Components

## Task 1: Create a step for logging into a container registry

The step will wrap logging in to a container registry using Docker and enable the reuse across pipelines:

1. Create a new directory called `steps/docker/login` with a file called `step.yml`
1. Add a `spec` header with an `inputs` section
1. Add an input called `registry` with a default value of `docker.io`
1. Add an input called `username` with no default value
1. Add an input called `password` with no default value
1. Create the step in the body using the [`exec.command`](https://docs.gitlab.com/ee/ci/steps/#execute-a-command) keyword
1. Use the `docker login` command with the provided inputs

??? info "Hint (Click if you are stuck)"
    - Inputs are used with the same syntax as in components: `$[[ inputs.<name> ]]`

??? example "Solution (Click if you are stuck)"
    `go/step.yml`:

    ```yaml
    spec:
      inputs:
        registry:
          type: string
          default: docker.io
        username:
          type: string
        password:
          type: string
    ---
    exec:
      command: docker login $[[ inputs.registry ]] --username $[[ inputs.username ]] --password $[[ inputs.password ]]
    ```

## Task 2: Use the step

The local step can be used in the job `package` in `.gitlab-ci.yml` by referencing the directory *without* `step.yml`:

1. Remove the `before_script`, `script` and `after_script` from the job `package`
1. Use the step `docker_login` in the `run` section of the job `package`
1. Provide values for `registry`, `username` and `password`

??? info "Hint (Click if you are stuck)"
    The credentials for the integrated container registry are provided as pre-defined environment variables:
    - Hostname in `${CI_REGISTRY}`
    - Username in `${CI_REGISTRY_USER}`
    - Password in `${CI_REGISTRY_PASSWORD}`

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml
    #...
    package:
      image: docker:28.1.1
      stage: package
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:28.1.1-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      variables:
        DOCKER_HOST: tcp://docker:2375
      run:
      - name: docker_login
        step: ./steps/docker/login/step.yml
        inputs:
          registry: ${CI_REGISTRY}
          username: ${CI_REGISTRY_USER}
          password: ${CI_REGISTRY_PASSWORD}
    #...
    ```

## Task 3: Create a step for building container images

Create and use a step for Docker build by converting the first command script block of the job `package` in `.gitlab-ci.yml`. The step should have two inputs called `context` and `image`.

??? info "Hint (Click if you are stuck)"
    - The name for a container image matching the current project is supplied in a pre-defined environment variable called `${CI_REGISTRY_IMAGE}`

??? example "Solution (Click if you are stuck)"
    `steps/docker/build/step.yml`:

    ```yaml
    spec:
    inputs:
        context:
        type: string
        default: .
        image:
        type: string
    ---
    exec:
    command: docker build --tag "$[[ inputs.image ]]" $[[ inputs.context ]]
    ```

    `.gitlab-ci.yml`:

    ```yaml
    #...
    package:
      image: docker:28.1.1
      stage: package
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:28.1.1-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      variables:
        DOCKER_HOST: tcp://docker:2375
      run:
      - name: docker_login
        step: ./steps/docker/login/step.yml
        inputs:
          registry: ${CI_REGISTRY}
          username: ${CI_REGISTRY_USER}
          password: ${CI_REGISTRY_PASSWORD}
      - name: docker_build
        step: ./steps/docker/build/step.yml
        inputs:
          context: .
          image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}
    #...
    ```

## Task 4: Create a step for pushing container images

Create and use a step for Docker build by converting the first command script block of the job `package` in `.gitlab-ci.yml`. The step should have one input called `image`.

??? info "Hint (Click if you are stuck)"
    Make sure the image name is the same as in the build step.

??? example "Solution (Click if you are stuck)"
    `steps/docker/push/step.yml`:

    ```yaml
    spec:
    inputs:
        context:
        type: string
        default: .
        image:
        type: string
    ---
    exec:
    command: docker push "$[[ inputs.image ]]"
    ```
    
    `.gitlab-ci.yml`:

    ```yaml
    #...
    package:
      image: docker:28.1.1
      stage: package
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:28.1.1-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      variables:
        DOCKER_HOST: tcp://docker:2375
      run:
      - name: docker_login
        step: ./steps/docker/login/step.yml
        inputs:
          registry: ${CI_REGISTRY}
          username: ${CI_REGISTRY_USER}
          password: ${CI_REGISTRY_PASSWORD}
      - name: docker_build
        step: ./steps/docker/build/step.yml
        inputs:
          context: .
          image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}
      - name: docker_push
        step: ./steps/docker/push/step.yml
        inputs:
          image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}
    #...
    ```

## Task 5: Create a step for logging out of a container registry

Create and use a step for Docker build by converting the first command script block of the job `package` in `.gitlab-ci.yml`. The step should have one input called `registry`.

??? info "Hint (Click if you are stuck)"
    The hostname of the integrated container registry is supplied in a pre-defined environment variable called `${CI_REGISTRY}`

??? example "Solution (Click if you are stuck)"
    `steps/docker/logout/step.yml`:

    ```yaml
    spec:
    inputs:
        registry:
        type: string
        default: docker.io
    ---
    exec:
    command: docker logout $[[ inputs.registry ]]
    ```
    
    `.gitlab-ci.yml`:

    ```yaml
    #...
    package:
      image: docker:28.1.1
      stage: package
      extends:
      - .run-on-push-to-default-branch
      services:
      - name: docker:28.1.1-dind
        command: [ "dockerd", "--host", "tcp://0.0.0.0:2375" ]
      variables:
        DOCKER_HOST: tcp://docker:2375
      run:
      - name: docker_login
        step: ./steps/docker/login/step.yml
        inputs:
          registry: ${CI_REGISTRY}
          username: ${CI_REGISTRY_USER}
          password: ${CI_REGISTRY_PASSWORD}
      - name: docker_build
        step: ./steps/docker/build/step.yml
        inputs:
          context: .
          image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}
      - name: docker_push
        step: ./steps/docker/push/step.yml
        inputs:
          image: ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_NAME}
      - name: docker_logout
        step: ./steps/docker/logout/step.yml
        inputs:
          registry: ${CI_REGISTRY}
    #...
    ```

## Bonus task: Move the step to a separate project

Move the steps into a separate project and use them from there. Check out the official documentation how to [use steps from a git repository](https://docs.gitlab.com/ee/ci/steps/#load-a-step-from-a-git-repository).

??? info "Hint 1 (Click if you are stuck)"
    Use a proper name for the project like `steps/docker` or `docker-steps` in an arbitraty namespace.

??? info "Hint 2 (Click if you are stuck)"
    Use the following directory structure to host all steps in the same project:

    ```plaintext
    login/
      step.yml
    build/
      step.yml
    push/
      step.yml
    logout/
      step.yml
    ```

??? info "Hint 3 (Click if you are stuck)"
    Use variables to reference the steps in the job:

    ```yaml
    my_job:
      run:
      - name: docker_login:
        step:
          git:
            url: ${CI_SERVER_HOST}/library/steps/docker
            dir: login
            rev: main
      #...
    ```
