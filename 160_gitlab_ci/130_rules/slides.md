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
  - if: $CI_PIPELINE_SOURCE == 'pipeline'
  - if: $CI_PIPELINE_SOURCE == 'api'
    when: never
  - if: $CI_PIPELINE_SOURCE == 'trigger'
    when: never
```

---

## Mind the order

Rules are evaluated in-order

First match determines result

Adjust order from most specific...

...to most general

---

## Hands-On

Use GitLab Pages to create a download page [](https://docs.gitlab.com/ee/user/project/pages/)

- The job must be called `pages` [](https://docs.gitlab.com/ee/ci/yaml/#pages)
- The must create an artifact from the directory called `public`

See chapter [Rules](/hands-on/2024-11-21/130_rules/exercise/)

---

## Pro tip 1: Use CI_DEPLOY_FREEZE with rules

Disable pipeline:

```yaml
workflow:
  rules:
  - if: $CI_DEPLOY_FREEZE
    when: never
  - when: on_success
```

Template to disable job:

```yaml
.freeze-deployment:
  rules:
  - if: $CI_DEPLOY_FREEZE
    when: manual
    allow_failure: true
  - when: on_success
```

---

## Pro tip 2: Fields for rules

Rules not only control execution of jobs but can also configure jobs through the use of the following fields:

- Add additional `variables` [](https://docs.gitlab.com/ee/ci/yaml/#rulesvariables) to customize the behaviour of the job
- Limit a rule to changes `changes` [](https://docs.gitlab.com/ee/ci/yaml/#ruleschanges) on specific files
- Execute a job only if a specific file `exists` [](https://docs.gitlab.com/ee/ci/yaml/#rulesexists)
- Make a job dependent on other jobs using `needs` [](https://docs.gitlab.com/ee/ci/yaml/#rulesneeds)

Rules become especially powerful when combining the fields supported by rules - including `if`

--

## Pro tip 3: Avoid pipeline on push

Pipelines can be skipped by adding `[skip ci]` to the commit message

But GitLab still shows a skipped pipelines

Use a rule to avoid pipelines entirely:

```
my_job:
  rules:
  - if: $CI_PIPELINE_SOURCE == "push" && $CI_COMMIT_TITLE =~ /skip ci/i
    when: never
```

---

## Pro tip 4: Use quotes to help the YAML parser

Sometime the YAML parser gets confused

Use quotes to help the parser

```yaml
workflow:
  rules:
  - if: '$VAR == "value"'

job_name:
  rules:
  - if: '$VAR2 == "value2"'
  #...
```

---

# Pro tip 5: Tweaking GitLab Pages

The content directory can be configured using `pages:publish` [](https://docs.gitlab.com/ee/ci/yaml/#pagespublish)

Premium/Ultimate: Deploy to a sub-directory `pages:pages.path_prefix` [](https://docs.gitlab.com/ee/ci/yaml/#pagespagespath_prefix)

Premium/Ultimate: Expire a pages deployment `pages:pages.expire_in` [](https://docs.gitlab.com/ee/ci/yaml/#pagespagesexpire_in)

---

# Pro tip 6: GitLab Pages access control

GitLab Pages are public by default

Access control can be enabled

1. Per instance [](https://docs.gitlab.com/ee/administration/pages/index.html#access-control) (prerequisite for per project)
1. Per project [](https://docs.gitlab.com/ee/user/project/pages/pages_access_control.html)
