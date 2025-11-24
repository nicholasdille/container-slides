# Merge requests

!!! tip "Goal"
    Learn how to...

    - run pipelines in the context of a merge request using rules
    - use template to avoid repetition when using rules

## Task 1: Use rules to run in merge request context

In the last chapter about `rules`, you learned how to use `$CI_PIPELINE_SOURCE` to restrict execution to specific events. You will need this now.

On the branch `main`, add rules to the jobs to specify when to run them:

1. Add rules the jobs `lint`, `audit`, `unit_tests`, `build` and `test` so that they are executed when...
    1. pushing to the default branch
    1. running in merge request context
1. Run the job `trigger` only when pushing to the default branch
1. Run the job `deploy` only when on the branches `dev` and `live`
1. Do not modify the existing rules for the job `pages`

Also add the merge request event to the workflow rules to allow the pipeline to run in merge request context.

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    `$CI_PIPELINE_SOURCE` can take the values `push` and `merge_request_event` in this context. `$CI_COMMIT_REF_NAME` contains the name of the Git reference (e.g. branch) the pipeline is running on. `$CI_DEFAULT_BRANCH` contains the name of the default branch of the repository in the current project. You can use the logical operator `&&` to combine multiple conditions.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="23 30 37 44 57"
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
      image: golang:1.25.3

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
1. Create a merge request into `main`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

## Bonus task: Explore additional predefined variables

On the branch of the merge request, add a job and run `printenv` to get a list of variables available to the pipeline. Check out additional variables specific to merge request pipelines. See also the [official documentation](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-for-merge-request-pipelines).

## Task 3: Avoid repetition using rule templates

In the first task we have implemented the same set of rules for multiple jobs. By combining rules with templates, this repetition can be avoided.

1. Create an inline template called `.run-on-push-to-default` with the corresponding rule(s)
1. Create a second inline template called `.run-on-push-and-mr` with the corresponding rule(s)
1. Modify the jobs to use the rule templates

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    Use `extends` to use the rule template in a job.

    Remember that only `variables` are kumulative. All other keywords overwrite each other in the order of appearance.

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="17-24 30-31 36-37 43 52 60-61 87-88 97-98"
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

    .run-on-push-to-default-branch:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'

    .run-on-push-and-in-mr:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'

    default:
      image: golang:1.25.3

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
