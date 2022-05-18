<!-- .slide: id="gitlab_merge_requests" class="vertical-center" -->

<i class="fa-duotone fa-merge fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Merge requests

---

## Merge requests

Merge requests enable collaboration

Pipelines can automatically test merge requests [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html)

Use rules [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) to decide which jobs to run when

Jobs require a rule to run for merge requests

Commits to a branch with merge request cause multiple events:

1. Push event to branch
1. Merge request event

Filter carefully!

---

## Hands-On 1/

1. Enable `lint`, `audit`, `build` and `test` for merge requests and pushes

    ```yaml
    job_name:
    rules:
    - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == "main"'
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      # ...
    ```

1. Prevent `deploy` in merge requests

    ```yaml
    job_name:
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      # ...
    ```

---

## Hands-On 2/2

3. Prevent `trigger` in merge requests

    ```yaml
    job_name:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == "main"'
      # ...
    ```

1. Check pipeline
1. Create new branch
1. Make dummy change in new branch
1. Create merge requests

(See new `.gitlab-ci.yml`)
