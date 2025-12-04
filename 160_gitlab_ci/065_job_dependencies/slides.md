<!-- .slide: id="gitlab_job_deps" class="vertical-center" -->

<i class="fa-duotone fa-cubes fa-8x" style="float: right; color: grey;"></i>

## Job dependencies

---

## Job dependencies 1/

Alternative approach to define order of jobs

Keyword `needs` [](https://docs.gitlab.com/ee/ci/yaml/#needs) references one or more jobs

Jobs are started as soon as possible

Option 1: Combine with stages

Option 2: Replacement for stages

---

## Mixing with stages

Start jobs from the next stage early:

```yaml
job1:
  stage: stage1
  #...
job2:
  stage: stage2
  needs:
  - job1
  #...
```

Delay jobs in the same stage:

```yaml
job1:
  stage: test
  #...
job2:
  stage: test
  needs:
  - job1
  #...
```

---

## Effect on artifacts

Depend on a job but do not consume artifacts [](https://docs.gitlab.com/ee/ci/yaml/#needsartifacts):

```yaml
job_name:
  #...

job_name2:
  needs:
  - job: job_name
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

## Comparison

Why `dependencies` and `needs`?

### `dependencies`

Has been around longer

Only intended for artifacts

### `needs`

Handles job execution order

Can be used for artifacts

---

## Hands-On: Job dependencies

Go to [exercises](/hands-on/2025-11-27/065_job_dependencies/exercise/)
