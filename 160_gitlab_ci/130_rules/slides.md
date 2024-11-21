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

## Hands-On

See chapter [Rules](/hands-on/2024-11-21/130_rules/exercise/)

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

## Pro tip: Fields for rules

Rules not only control execution of jobs but can also configure jobs through the use of the following fields:

- Add additional `variables` [](https://docs.gitlab.com/ee/ci/yaml/#rulesvariables) to customize the behaviour of the job
- Limit a rule to changes `changes` [](https://docs.gitlab.com/ee/ci/yaml/#ruleschanges) on specific files
- Execute a job only if a specific file `exists` [](https://docs.gitlab.com/ee/ci/yaml/#rulesexists)
- Make a job dependent on other jobs using `needs` [](https://docs.gitlab.com/ee/ci/yaml/#rulesneeds)

Rules become especially powerful when combining the fields supported by rules - including `if`
