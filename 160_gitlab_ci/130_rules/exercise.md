# Rules

!!! tip "Goal"
    Learn how to...

    - define when to run jobs (and when not)
    - how (workflow) rules can apply to whole pipelines
    - how to use [GitLab Pages](https://docs.gitlab.com/ee/user/project/pages/index.html) to publish static web pages

In this exercise we will publish a static web page to download the `hello` binary.

## Preparation

Add a file `public/index.html` to your project using the following command:

```bash
git checkout upstream/160_gitlab_ci/130_rules -- 'public/index.html'
```

## Task 1: Prevent a job from running

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

Review the official documentation for the [`rules`](https://docs.gitlab.com/ee/ci/yaml/#rules) keyword to limit the job `pages` to run when...

- the pipeline was triggered by a push event AND
- the change applied to the default branch

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint 1 (Click if you are stuck)"
    In [pre-defined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html) see `$CI_PIPELINE_SOURCE` for trigger events, `$CI_COMMIT_REF_NAME` for the current Git reference and `$CI_DEFAULT_BRANCH` for the default branch.

??? info "Hint 2 (Click if you are stuck)"
    See [complex rules](https://docs.gitlab.com/ee/ci/jobs/job_control.html#complex-rules) for combining conditions using and (`&&`) and or (`||`).

??? example "Solution (Click if you are stuck)"
    `.gitlab-ci.yml`:

    ```yaml linenums="1" hl_lines="63-72"
    include:
    - local: go.yaml

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

    lint:
      stage: check
      script:
      - go fmt .

    audit:
      stage: check
      script:
      - go vet .

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
      artifacts:
        paths:
        - hello

    test:
      stage: test
      image: alpine
      script:
      - ./hello

    deploy:
      stage: deploy
      environment:
        name: ${CI_COMMIT_REF_NAME}
      image: curlimages/curl:8.13.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.${CI_COMMIT_REF_NAME}.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public
      artifacts:
        paths:
        - public

    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/130_templates -- '*'
    ```

## Task 2: Prevent a pipeline from running

Rules can also be placed under the global [`workflow`](https://docs.gitlab.com/ee/ci/yaml/#workflowrules) keyword to apply to the whole pipeline instead of individual jobs.

Allow the pipeline to run for the triggers `push`, `web`, `schedule` and `pipeline` and prevent the pipeline for triggers `api` and `trigger`.

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

    ```yaml linenums="1" hl_lines="1-11"
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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

    lint:
      stage: check
      script:
      - go fmt .

    audit:
      stage: check
      script:
      - go vet .

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
      artifacts:
        paths:
        - hello

    test:
      stage: test
      image: alpine
      script:
      - ./hello

    deploy:
      stage: deploy
      environment:
        name: dev
      image: curlimages/curl:8.13.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public/
      artifacts:
        paths:
        - public

    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/130_rules_workflow -- '*'
    ```

## Task 3: Use deploy freeze

Projects can define a [deploy freeze](https://docs.gitlab.com/ee/user/project/releases/index.html#prevent-unintentional-releases-by-setting-a-deploy-freeze) to prevent pipelines to run but the settings only results in an environment variable `$CI_DEPLOY_FREEZE`. Rules as well as workflow rules can be used to enforce deploy freezes.

Modify the pipeline to prevent the execution when `$CI_DEPLOY_FREEZE` is not empty.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint 1 (Click if you are stuck)"
    Simply enter the variable into a rule to check if it is not empty.

??? info "Hint 2 (Click if you are stuck)"
    Checkout the [`when`](https://docs.gitlab.com/ee/ci/yaml/#when) keyword under [`if`](https://docs.gitlab.com/ee/ci/yaml/#rulesif) to control whether to start a pipeline/job or not.

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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.23.2

    lint:
      stage: check
      script:
      - go fmt .

    audit:
      stage: check
      script:
      - go vet .

    unit_tests:
      stage: check
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .build-go
      artifacts:
        paths:
        - hello

    test:
      stage: test
      image: alpine
      script:
      - ./hello

    deploy:
      stage: deploy
      environment:
        name: dev
      image: curlimages/curl:8.13.0
      script:
      - |
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      image: alpine
      script:
      - cp hello public/
      artifacts:
        paths:
        - public

    trigger:
      stage: trigger
      trigger:
        include: child.yaml
    ```

This was just a demonstration. The changes will not be preserved in the following chapters.

<!-- TODO: reuse rules with templates (https://docs.gitlab.com/ee/ci/jobs/job_control.html#reuse-rules-in-different-jobs) -->
