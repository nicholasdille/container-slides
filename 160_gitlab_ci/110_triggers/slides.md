<!-- .slide: id="gitlab_triggers" class="vertical-center" -->

<i class="fa-duotone fa-play fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Triggers

---

## Trigger other pipelines

Ability to split automation across multiple pipeline

### Trigger tokens

Trigger pipelines through the API [](https://docs.gitlab.com/ee/ci/triggers/)

Fire and forget

### Multi-project pipelines

Launch pipeline in separate project [](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)

Use the `trigger` keyword [](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger)

### Parent-child pipelines

Load stages and jobs from a file using `include` [](https://docs.gitlab.com/ee/ci/pipelines/parent_child_pipelines.html)

---

## Nomenclature

The preceding pipeline is **upstream**

The following pipeline is **downstream**

The pipeline triggering you is the **upstream pipeline**

The pipeline you trigger is the **downstream pipeline**

![](160_gitlab_ci/110_triggers/upstream_downstream.drawio.svg) <!-- .element: style="width: 70%; margin-top: 0.5em;" -->

Relationship between pipelines in the above picture:

- Pipeline 1 is upstream of pipeline 2
- Pipeline 2 is downstream of pipeline 1
- Pipeline 2 is upstream of pipeline 3
- Pipeline 3 is downstream of pipeline 2

---

## Heads-up for trigger tokens

### Visibility of trigger tokens

Users sees only their own tokens

Tokens of other users are hidden

### Branch protection can prevent triggers

Trigger owner must be able to either...

- Push to a branch
- Merge into a branch

---

## Multi-project pipelines

Modern alternative to trigger tokens

Launch pipeline in separate project [](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)

Use the `trigger` keyword [](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger)

### Example

```yaml
job_name:
  trigger:
    project: <path-to-project>
    branch: main
```

`trigger.branch` is optional

---

## Parent-child pipelines

Child pipeline can be made from multiple files

`include` supports `local` for files in the same repository

Use `project`/`ref`/`file` for files in other repositories

### Example

```yaml
job_name:
  trigger:
    include: <relative-path-to-file>

job_name2:
  trigger:
    include:
    - project: <path-to-project>
      ref: main
      file: <relative-path-to-file>
```

File must match `/\.ya?ml$/`

---

## Hands-On

See chapter [Triggers](/hands-on/2023-11-30/110_triggers/exercise/)

---

## Pro tip 1: Variable inheritence

Downstream pipelines inherit some variables [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html#pass-cicd-variables-to-a-downstream-pipeline)

Job variables are passed on unless:

```yaml
job_name:
  inherit:
    variables: false
```

Predefined variables must be redefined as job variables:

```yaml
job_name:
  variables:
    my_var: ${CI_COMMIT_REF_NAME}
  trigger:
    #...
```

Do not redefined masked variables - **they will not be masked**

---

## Pro tip 2: Wait for downstream pipeline

Upstream pipeline only waits for successful trigger

Wait for successul downstream pipeline using `strategy` [](https://docs.gitlab.com/ee/ci/yaml/#triggerstrategy)

```yaml
job_name:
  trigger:
    include: child.yaml
    strategy: depend
```

---

## Dynamic includes

Included file can also be generated before job start [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html#dynamic-child-pipelines)

```yaml
generate:
  script:
  - |
    cat <<EOF >child.yaml
    test:
      script:
      - printenv
    EOF
  artifacts:
    paths:
    - child.yaml

use:
  trigger:
    include:
    - artifact: child.yaml
      job: generate
```

---

## Pro tip: Artifacts from parent pipeline

<i class="fa-duotone fa-triangle-exclamation"></i> Requires Enterprise Edition Premium [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html?tab=Multi-project+pipeline#fetch-artifacts-from-an-upstream-pipeline)

Generate artifact and trigger child pipeline:

```yaml
build_artifacts:
  stage: build
  script: echo "This is a test artifact!" >> artifact.txt
  artifacts:
    paths:
    - artifact.txt

deploy:
  stage: deploy
  trigger:
    include:
    - local: path/to/child-pipeline.yml
  variables:
    PARENT_PIPELINE_ID: $CI_PIPELINE_ID
```

<!-- .element: style="font-size: medium;" -->

Fetch artifact from parent pipeline

```yaml
test:
  stage: test
  script: cat artifact.txt
  needs:
  - pipeline: $PARENT_PIPELINE_ID
    job: build_artifacts
```
<!-- .element: style="font-size: medium;" -->

---

## Pro tip: Do not pass global variables

Only allow job variables to be passed to downstream pipelines:

```yaml
variables:
  GLOBAL_VAR: value

trigger-job:
  inherit:
    variables: false
  variables:
    JOB_VAR: value
  trigger:
    include:
    - local: path/to/child-pipeline.yml
```
