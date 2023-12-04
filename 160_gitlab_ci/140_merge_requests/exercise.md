# Merge requests

!!! tip "Goal"
    Learn how to...

    - run pipelines in the context of a merge request using rules
    - use template to avoid repetition when using rules

## Task 1: Use rules to run in merge request context

In the last chapter about `rules`, you learned how to use `$CI_PIPELINE_SOURCE` to restrict execution to specific events. You will need this now.

On the branch `main`, add rules to the jobs to specify when to run them:

1. For the jobs `lint`, `audit`, `unit_tests`, `build` and `test`, add rules so that the jobs are executed when...
    1. pushing to the default branch
    1. running in merge request context
1. Run the job `trigger` only when pushing to the default branch
1. Do not modify the existing rules for the job `pages`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

??? info "Hint (Click if you are stuck)"
    XXX

??? example "Solution (Click if you are stuck)"
    ```yaml linenums="1" hl_lines="30-32 38-40 46-48 59-61 70-72 79-80 106-107"
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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.19.2

    lint:
      stage: check
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      script:
      - go fmt .

    audit:
      stage: check
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      script:
      - go vet .

    unit_tests:
      stage: check
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml --format testname
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      extends:
      - .build-go
      artifacts:
        paths:
        - hello

    test:
      stage: test
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      image: alpine
      script:
      - ./hello

    deploy:
      stage: deploy
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      environment:
        name: dev
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
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
      script:
      - cp hello public/
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == $CI_DEFAULT_BRANCH'
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout origin/160_gitlab_ci/140_merge_requests -- '*'
    ```

## Task 2: Create a merge request

Now we want to check which jobs are executed in the context of a merge request:

1. Create a new branch based on `main`
1. Create a merge request into `main`

Afterwards check the pipeline in the GitLab UI. You should see a successful pipeline run.

## Bonus: Explore additional predefined variables

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
    ```yaml linenums="1" hl_lines="18-25 39-40 46-47 53-55 65-66 75-76 83-84 100-101 110-111"
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

    stages:
    - check
    - build
    - test
    - deploy
    - trigger

    default:
      image: golang:1.19.2

    lint:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go fmt .

    audit:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go vet .

    unit_tests:
      stage: check
      extends:
      - .run-on-push-and-in-mr
      script:
      - go install gotest.tools/gotestsum@latest
      - gotestsum --junitfile report.xml --format testname
      artifacts:
        when: always
        reports:
          junit: report.xml

    build:
      stage: build
      extends:
      - .run-on-push-and-in-mr
      extends:
      - .build-go
      artifacts:
        paths:
        - hello

    test:
      stage: test
      extends:
      - .run-on-push-and-in-mr
      image: alpine
      script:
      - ./hello

    deploy:
      stage: deploy
      extends:
      - .run-on-push-to-default-branch
      environment:
        name: dev
      before_script:
      - apt-get update
      - apt-get -y install curl ca-certificates
      script:
      - |
        curl https://seat${SEAT_INDEX}.dev.webdav.inmylab.de/ \
            --fail \
            --verbose \
            --upload-file hello \
            --user seat${SEAT_INDEX}:${PASS}

    pages:
      stage: deploy
      extends:
      - .run-on-push-to-default-branch
      script:
      - cp hello public/
      artifacts:
        paths:
        - public
    
    trigger:
      stage: trigger
      extends:
      - .run-on-push-to-default-branch
      trigger:
        include: child.yaml
    ```
    
    If you want to jump to the solution, execute the following command:

    ```bash
    git checkout origin/160_gitlab_ci/140_merge_requests_rule_templates -- '*'
    ```
