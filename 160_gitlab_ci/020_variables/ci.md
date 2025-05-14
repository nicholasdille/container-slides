<!-- .slide: id="gitlab_ci_variables" -->

## CI variables

Stored securely in the GitLab server

Injected into jobs at runtime

Available in project-, group- and instance-level

Careful with protected variables

### Hands-On

See chapter [Variables](/hands-on/2025-05-14/020_variables/exercise/)

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
