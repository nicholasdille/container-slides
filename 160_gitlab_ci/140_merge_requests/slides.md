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

XXX difference

Use rules [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_rules) to decide which jobs to run when

GitLab offers `$CI_PIPELINE_SOURCE` with event name

---

## Hands-On

See chapter [Merge requests](/hands-on/20231130/140_merge_requests/exercise/)
