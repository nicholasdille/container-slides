# Rules

We will learn how to use rules to control when a job is executed. We will publish a static web page as a download page for the `hello` binary.

!!! tip "Goal"
    Learn how to...

    - define when to run jobs (and when not)
    - how (workflow) rules can apply to whole pipelines
    - how to use [GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/index.html) to publish static web pages

## Preparation

Add a file `public/index.html` to your project using the following command:

```bash
git checkout upstream/160_gitlab_ci/130_rules -- 'public/index.html'
```

Add a job `pages` to the stage `deploy` with the following content:

```yaml
pages:
  stage: deploy
  script:
  - cp hello public/
  artifacts:
    paths:
    - public
```

## Task 1: Control job execution

Use the `rules` keyword to limit when the new job `pages` is executed. The conditions should allow the job to run, when the pipeline was triggered by a push event and the change was applied to the default branch.

Also add conditions to the job `deploy` to limit execution to the branches `dev` and `live`.

See the official documentation for the [`rules`](https://docs.gitlab.com/ee/ci/yaml/#rules) keyword and the [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint 1 (Click if you are stuck)"
    In [pre-defined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html) see `$CI_PIPELINE_SOURCE` for trigger events, `$CI_COMMIT_REF_NAME` for the current Git reference and `$CI_DEFAULT_BRANCH` for the default branch.

??? info "Hint 2 (Click if you are stuck)"
    See [complex rules](https://docs.gitlab.com/ee/ci/jobs/job_control.html#complex-rules) for combining conditions using and (`&&`) and or (`||`).

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="40-41 53-64"
    include:
    - local: go.yaml

    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    unit_tests:
      extends:
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello

    deploy:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public
      artifacts:
        paths:
        - public

    trigger:
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/130_rules -- '*'
    ```

## Task 2: Control pipeline execution

Allow the pipeline to run for the events `push`, `web`, `schedule` and `pipeline` and prevent the pipeline for events `api` and `trigger`.

See the official documentation of the [`workflow`](https://docs.gitlab.com/ee/ci/yaml/#workflowrules) keyword to control the execution of the whole pipeline instead of individual jobs.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    The syntax of `workflow` looks like this:

    ```yaml
    workflow:
      rules:
      #...
    ```

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="1-10"
    workflow:
      rules:
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never

    include:
    - local: go.yaml

    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    unit_tests:
      extends:
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello

    deploy:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public/hello
      artifacts:
        paths:
        - public

    trigger:
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/130_rules_workflow -- '*'
    ```

## Task 3: Implement a deploy freeze

Projects can define a [deploy freeze](https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze) to prevent deployments to run. Configuring this setting results in a new environment variable called `$CI_DEPLOY_FREEZE`. Rules as well as workflow rules can be used to enforce deploy freezes.

Modify the pipeline to prevent the execution when `$CI_DEPLOY_FREEZE` is not empty.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint 1 (Click if you are stuck)"
    Simply enter the variable name into a rule to check if it is not empty.

??? info "Hint 2 (Click if you are stuck)"
    Checkout the [`when`](https://docs.gitlab.com/ee/ci/yaml/#when) keyword and place it under the [`if`](https://docs.gitlab.com/ee/ci/yaml/#rulesif) keyword to control pipeline/job execution.

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:
    
    ```yaml linenums="1" hl_lines="3-4"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never
      
    include:
    - local: go.yaml

    default:
      image: golang:1.25.4

    lint:
      script:
      - go fmt .

    audit:
      script:
      - go vet .

    unit_tests:
      extends:
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      image: alpine
      script:
      - ./hello

    deploy:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.17.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      needs:
      - build
      - unit_tests
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public/hello
      artifacts:
        paths:
        - public

    trigger:
      trigger:
        include: child.yaml
    ```
