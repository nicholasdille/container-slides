<!-- .slide: id="gitlab_artifacts" class="vertical-center" -->

<i class="fa-duotone fa-cubes fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Artifacts

---

## Artifacts

Transfer files between jobs using `artifacts` [](https://docs.gitlab.com/ee/ci/yaml/#artifacts)

All jobs in subsequent stages will receive the artifacts (by default)

![](160_gitlab_ci/060_artifacts/artifacts.drawio.svg) <!-- .element: style="width: 50%; float: right;" -->

### Configuration

`artifacts` can be in `default` [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_default)

Include and exclude paths

Expire artifacts

Name artifacts

Add untracked files

When to create artifacts (jobs success, failure, always)

---

## Hands-On

Test binary in a new job and stage

1. Create artifact from `hello` binary
1. Add new stage called `test`
1. Add new job in stage `test`
1. Execute binary to test it

(See new `.gitlab-ci.yml`)

---

## Dependencies

Jobs can receive artifacts from only some previous jobs

Done using `dependencies` [](https://docs.gitlab.com/ee/ci/yaml/#dependencies)

Empty list disables receiving artifacts:

```yaml
job_name:
  # ...
  dependencies: []
  # ...
```
