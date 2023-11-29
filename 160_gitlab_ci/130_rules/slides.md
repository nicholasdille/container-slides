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

## Hands-On: Rules

See chapter [Rules](/hands-on/20231130/130_rules/exercise/)

Also see GitLab Pages [](https://docs.gitlab.com/ee/user/project/pages/index.html)

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

## Hands-On: Workflow rules

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

See chapter [Rules](/hands-on/20231130/130_rules/exercise/)

---

## Pro tip: Mind the order

Rules are evaluated in-order

First match determines result

Adjust order from most specific...

...to most general

---

## Pro tip: Rule templates

Pipelines often have many jobs

Rules will be repeated multiple times

Combine rules with templates to prevent repetition

```yaml
.rule-only-web:
  rules:
  - if: $CI_PIPELINE_SOURCE == 'web'

job_name:
  extends:
  - .rule-only-web
  #...
```

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
