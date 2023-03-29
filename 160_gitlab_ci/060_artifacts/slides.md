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

## Hands-On [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/060_artifact "060_artifact")

Test binary in a new job and stage

1. Create artifact from `hello` binary
1. Add new stage called `test`
1. Add new job in stage `test`
1. Execute binary to test it

See new `.gitlab-ci.yml`:

```bash
git checkout 060_artifact -- '*'
```

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

## Job dependencies using `needs` 1/

`needs` [](https://docs.gitlab.com/ee/ci/yaml/#needs) can start jobs from the next stage early...

```yaml
job1:
  stage: stage1
  #...
job2:
  stage: stage2
  needs: job1
  #...
```

...or delay them in the same stage

```yaml
job1:
  stage: test
  #...
job2:
  stage: test
  needs: job1
  #...
```

---

## Job dependencies using `needs` 2/2

Depend on a job but do not consume artifacts [](https://docs.gitlab.com/ee/ci/yaml/#needsartifacts):

```yaml
job_name:
  #...

job_name2:
  needs:
    job: job_name
    artifacts: false
```

Consume artifacts from parent (upstream) pipeline [](https://docs.gitlab.com/ee/ci/yaml/#needspipelinejob):

```yaml
job_name:
  script: cat artifact.txt
  needs:
    - pipeline: $PARENT_PIPELINE_ID
      job: create-artifact
```

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
