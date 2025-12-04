<!-- .slide: id="gitlab_variables" class="vertical-center" -->

<i class="fa-duotone fa-square-root-variable fa-8x" style="float: right; color: grey;"></i>

## Variables

---

## Flavors

Variables [](https://docs.gitlab.com/ee/ci/yaml/#variables) can be...

- defined in the pipeline definition
- predefined by GitLab
- defined in the UI

---

## Variables

Variables can be defined...

...for the whole pipeline or...

...for a job

```yaml
variables:
  version: unknown

my_job:
  variables:
    version: dev
  script:
  - echo "${version}"
```

Job variables overwrite pipeline variables

---

<!-- .slide: id="gitlab_predefined_variables" -->

## Predefined variables

GitLab offers many [predefined variables](https://docs.gitlab.com/ee/ci/variables/predefined_variables.html)

Most describe the current job, stage and pipeline

Some describe the GitLab server

Some help interacting with the GitLab server

---

<!-- .slide: id="gitlab_ci_variables" -->

## CI/CD variables

Stored securely in the GitLab server

Injected into jobs at runtime

Available in project-, group- and instance-level

Careful with protected variables

---

## Hands-On: Variables

Go to [exercises](/hands-on/2025-11-27/020_variables/exercise/)

---

## Pro tip 1: Masked variables for all values

Many values are rejected by GitLab

Store base64-encoded values

Decode values before use:

```yaml
job_name:
  script:
  - echo "$( echo "${MASKED_VAR}" | base64 -d )"
```

Careful! Original value will not be masked!

---

## Pro tip 2: Protect masked variables

Prevent project maintainers/owners to read masked CI variables:

1. Define variable in parent group
2. Limit permissions to group

### Still security by obscurity

But masked values can always be leaked through a pipeline:

```yaml
job_name:
  script:
  - echo "${MASKED_VAR}" | base64
```
