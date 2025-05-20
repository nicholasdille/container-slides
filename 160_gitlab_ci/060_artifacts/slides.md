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

## Hands-On

See chapter [Artifacts](/hands-on/2025-05-14/060_artifacts/exercise/)

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

`dependencies` limits from which jobs artifacts are consumed

---

## Maximum artifact size

By default, artifacts can not be larger than 100MB [](https://docs.gitlab.com/administration/settings/continuous_integration/#set-maximum-artifacts-size)

Can be configured...

- for the whole instance
- per group
- per project

Only available to instance administrators

---

## Conflicting artifact names

When two jobs produce an artifact with the same name...

...the last job to finish wins

---

## Artifact retention

Defaults to keep artifacts from most recent successful jobs
- Project settings [](https://docs.gitlab.com/ee/ci/jobs/job_artifacts.html#keep-artifacts-from-most-recent-successful-jobs)
- Instance settings [](https://docs.gitlab.com/ee/administration/settings/continuous_integration.html#keep-the-latest-artifacts-for-all-jobs-in-the-latest-successful-pipelines)

If enabled, `expire_in` does not apply to most recent artifacts
