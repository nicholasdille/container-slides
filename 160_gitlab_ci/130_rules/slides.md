<!-- .slide: id="gitlab_rules" class="vertical-center" -->

<i class="fa-duotone fa-book-section fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Rules

---

## Make jobs conditional

Rules [](https://docs.gitlab.com/ee/ci/yaml/#rules) define whether to execute a job

At least one successful rule for the job to be executed

```yaml
job_name:
  rules:
  - if: $VAR == "value"
  - if: $VAR2 = "value2"
  #...
```

Formerly `only`/`except` [](https://docs.gitlab.com/ee/ci/yaml/#only--except) which are "not actively developed"

Official documentation of job control [](https://docs.gitlab.com/ee/ci/jobs/job_control.html)

---

## Make pipelines conditional

Workflow rules [](https://docs.gitlab.com/ee/ci/yaml/#workflow) define whether to execute a whole pipeline

```yaml
workflow:
  rules:
  - if: $VAR == "value"
  - if: $VAR2 = "value2"

job_name:
  #...
```

Conditions are also used in workflow rules 

---

## Workflow rules

Disable execution for some trigger types

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

---

## Pro tip: Mind the order

Rules are evaluated in-order

First match determines result

Adjust order from most specific...

...to most general

---

## Pro tip: Use CI_DEPLOY_FREEZE with rules

Disable pipeline:

```yaml
workflow:
  rules:
  - if: '$CI_DEPLOY_FREEZE'
    when: manual
  - when: on_success
```

Template to disable job:

```yaml
.freeze-deployment:
  rules:
  - if: '$CI_DEPLOY_FREEZE'
    when: manual
    allow_failure: true
  - when: on_success
```

---

## Hands-On

See chapter [Rules](/hands-on/2024-11-12/130_rules/exercise/)
