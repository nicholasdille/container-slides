<!-- .slide: id="gitlab_merge_requests" class="vertical-center" -->

<i class="fa-duotone fa-merge fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Merge requests

---

## Merge requests

Merge requests enable collaboration

Pipelines can automatically test merge requests [](https://docs.gitlab.com/ee/ci/pipelines/merge_request_pipelines.html)

Commits to a branch with a merge request cause multiple events:

1. Push event to branch
1. Merge request event

Use rules [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) to decide which jobs to run when

GitLab offers `$CI_PIPELINE_SOURCE` with event name

---

## Hands-On 1/ [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/160_gitlab_ci/140_merge_requests/.gitlab-ci.yml "160_gitlab_ci/140_merge_requests/.gitlab-ci.yml")

1. Enable jobs `lint`, `audit`, `build` and `test` for merge requests and pushes

    ```yaml
    job_name:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == "main"'
      - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      #...
    ```
    <!-- .element: style="width: 45em;" -->

1. Prevent `deploy` in merge requests

    ```yaml
    job_name:
      rules:
      - if: '$CI_COMMIT_REF_NAME == "dev" || $CI_COMMIT_REF_NAME == "live"'
      #...
    ```
    <!-- .element: style="width: 45em;" -->

---

## Hands-On 2/2 [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/160_gitlab_ci/140_merge_requests/.gitlab-ci.yml "160_gitlab_ci/140_merge_requests/.gitlab-ci.yml")

3. Prevent `trigger` in merge requests

    ```yaml
    job_name:
      rules:
      - if: '$CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_REF_NAME == "main"'
      #...
    ```
    <!-- .element: style="width: 45em;" -->

1. Check pipeline
1. Create new branch
1. Make dummy change in new branch
1. Create merge requests
1. Check pipelines and merge requests

(See new `.gitlab-ci.yml`)
