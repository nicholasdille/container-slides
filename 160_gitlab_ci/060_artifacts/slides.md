<!-- .slide: id="gitlab_artifacts" class="vertical-center" -->

<i class="fa-duotone fa-cubes fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Artifacts

---

## Artifacts

Transfer files between jobs using `artifacts` [](https://docs.gitlab.com/ee/ci/yaml/#artifacts)

All jobs in subsequent stages will receive the artifacts (by default)

![](160_gitlab_ci/060_artifacts/artifacts.drawio.svg) <!-- .element: style="width: 50%; float: right;" -->

### Configuration

Name artifacts

Include and exclude paths

When to create artifacts (jobs success, failure, always)

Expire artifacts

Add untracked files

`artifacts` can be in `default` [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_default)

---

## Hands-On

See chapter [Artifacts](/hands-on/20231130/060_artifacts/exercise/)

---

## Dependencies

Jobs can restrict which job artifacts to receive

Add `dependencies` [](https://docs.gitlab.com/ee/ci/yaml/#dependencies)

```yaml
job_name:
  dependencies:
  - other_job
  #...
```

Empty list disables receiving artifacts:

```yaml
job_name:
  dependencies: []
  #...
```

### Download artifact from another pipeline

See GitLab API [](https://docs.gitlab.com/ee/api/job_artifacts.html#download-the-artifacts-archive)

---

## Pro tip: When variables are enough

Passing variables between jobs **is** possible (since GitLab 12.9)

One job defined a `dotenv` artifact [](https://docs.gitlab.com/ee/ci/variables/index.html#pass-an-environment-variable-to-another-job):

```yaml
job_name:
  script: echo "FOO=bar" >build.env
  artifacts:
    reports:
      dotenv: build.env
```

Job in later stages automatically consume them:

```yaml
job_name2:
  script: echo "${FOO}"
```

`dependencies` as well as `needs` limit from which jobs they are consumed
