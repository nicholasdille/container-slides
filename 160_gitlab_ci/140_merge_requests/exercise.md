# Merge requests

We will explore how pipelines behave for merge requests. This will require the use of the `rules` keyword.

!!! tip "Goal"
    Learn how to...

    - run pipelines in the context of a merge request using rules
    - use templates to avoid repetition when using rules

## Task 1: Allow pipeline in merge request context

Pipelines are usually only executed in branch context but not in merge request context. Before taking a closer look at jobs we need to extends the `workflow` rules.

Extend the `workflow` rules to allow the pipeline to run for merge requests using `$CI_PIPELINE_SOURCE`.

See the [official documentation about trigger events](https://docs.gitlab.com/ci/jobs/job_rules/#ci_pipeline_source-predefined-variable) for the appropriate event name.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="8"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never

    # ...
    ```

## Task 2: Run jobs in merge request context

On the branch `main`, add rules to specify when to run the jobs:

1. Add rules the jobs `lint`, `audit`, `unit_tests`, `build` and `test` so that they are executed when...
    1. pushing to the default branch
    1. running in merge request context
1. Run the job `trigger` only when pushing to the default branch
1. Run the job `deploy` only when on the branches `dev` and `live`
1. Do not modify the existing rules for the job `pages`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    `$CI_PIPELINE_SOURCE` can take the values `push` and `merge_request_event` in this context. `$CI_COMMIT_REF_NAME` contains the name of the Git reference (e.g. branch) the pipeline is running on. `$CI_DEFAULT_BRANCH` contains the name of the default branch of the repository in the current project. You can use the logical operator `&&` to combine multiple conditions.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="24 31 38 45 58"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
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
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      script:
      - go fmt .

    audit:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      script:
      - go vet .

    unit_tests:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      extends:
      - .unit-tests-go

    build:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
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
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      needs:
      - build
      - unit_tests
      image: alpine
      script:
      - cp hello public/hello
      artifacts:
        paths:
        - public

    trigger:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/140_merge_requests -- '*'
    ```

## Task 2: Create a merge request

Now we want to check which jobs are executed in the context of a merge request:

1. Create a new branch based on `main`
1. Push a change to the new branch, e.g. small change to the `README.md` file
1. Create a merge request from your new branch into `main`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

Also check the differences between branch pipelines and merge request pipelines.

Also open the merge requests and note that it displays the state (concerning the pipeline, approvals and merge conflicts) and offers an overview of the commits and the kumulative changes.

## Bonus task: Explore additional predefined variables

See the [official documentation](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-for-merge-request-pipelines) to learn about the predefined variables available for merge request pipelines.

## Task 3: Avoid repetition using rule templates

So far, we have implemented the same set of rules for multiple jobs. By combining rules with templates, this repetition can be avoided.

1. Create an inline template called `.run-on-push-to-default` with the corresponding rule(s)
1. Create a second inline template called `.run-on-push-and-mr` with the corresponding rule(s)
1. Modify the jobs to use the rule templates

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Use `extends` to use the rule template in a job.

    Remember that only `variables` are kumulative. All other keywords overwrite each other in the order of appearance.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="18-25 31-32 37-38 44 53 61-62 88-89 98-99"
    workflow:
      rules:
      - if: $CI_DEPLOY_FREEZE
        when: never
      - if: $CI_PIPELINE_SOURCE == 'push'
      - if: $CI_PIPELINE_SOURCE == 'web'
      - if: $CI_PIPELINE_SOURCE == 'schedule'
      - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
      - if: $CI_PIPELINE_SOURCE == 'pipeline'
      - if: $CI_PIPELINE_SOURCE == 'api'
        when: never
      - if: $CI_PIPELINE_SOURCE == 'trigger'
        when: never

    include:
    - local: go.yaml

    .run-on-push-to-default-branch:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'

    .run-on-push-and-in-mr:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

    default:
      image: golang:1.25.4

    lint:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go fmt .

    audit:
      extends:
      - .run-on-push-and-in-mr
      script:
      - go vet .

    unit_tests:
      extends:
      - .run-on-push-and-in-mr
      - .unit-tests-go

    build:
      needs:
      - lint
      - audit
      - unit_tests
      extends:
      - .run-on-push-and-in-mr
      - .build-go
      variables:
        version: $CI_COMMIT_REF_NAME

    test:
      needs:
      - build
      extends:
      - .run-on-push-and-in-mr
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
      extends:
      - .run-on-push-to-default-branch
      image: alpine
      script:
      - cp hello public/hello
      artifacts:
        paths:
        - public

    trigger:
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout upstream/160_gitlab_ci/140_merge_requests_rule_templates -- '*'
    ```
