<!-- .slide: id="gitlab_rules" class="vertical-center" -->

<i class="fa-duotone fa-book-section fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Rules

---

## Rules

XXX [](https://docs.gitlab.com/ee/ci/yaml/#rules)

XXX requires one successful rule for the job to be added

XXX [](https://docs.gitlab.com/ee/ci/jobs/job_control.html)

XXX formerly: only/except [](https://docs.gitlab.com/ee/ci/yaml/#only--except)

XXX Workflow rules [](https://docs.gitlab.com/ee/ci/yaml/#workflow)

---

## Hands-On: Rules

XXX deploy only from main

1. Create folder `public`
1. Add files from `public/` to new folder `public`
1. Update `.gitlab-ci.yml`
1. Check pipeline
1. Go to **Settings** > **Pages** > XXX
1. Open GitLab Pages [](https://docs.gitlab.com/ee/user/project/pages/index.html)
1. Create branch
1. Check pipeline

---

## Hands-On: Workflow rules

XXX disable execution for some trigger types

```yaml
workflow:
  rules:
  - if: $CI_PIPELINE_SOURCE == 'push'
  - if: $CI_PIPELINE_SOURCE == 'web'
  - if: $CI_PIPELINE_SOURCE == 'schedule'
  - if: $CI_PIPELINE_SOURCE == 'merge_request_event'
  - if: $CI_PIPELINE_SOURCE == 'pipeline'
  - if: $CI_PIPELINE_SOURCE == 'api'
    when: never
  - if: $CI_PIPELINE_SOURCE == 'trigger'
    when: never
```
