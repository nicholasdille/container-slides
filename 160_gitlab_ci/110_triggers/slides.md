<!-- .slide: id="gitlab_triggers" class="vertical-center" -->

<i class="fa-duotone fa-play fa-8x" style="float: right; color: grey;"></i>

## Triggers

---

## Trigger other pipelines

Ability to split automation across multiple pipeline

### Trigger tokens

Trigger [](https://docs.gitlab.com/ee/ci/triggers/) pipelines through the API

Fire and forget

### Multi-project pipelines

Launch pipeline in separate project [](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)

Use the `trigger` [](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger) keyword

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

### Fire and forget

Unable to check pipeline status

---

## Multi-project pipelines

Modern alternative to trigger tokens

Launch pipeline in separate project [](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)

Use the `trigger` [](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger) keyword

### Examples

Trigger a pipeline in another project:

```yaml
job_name:
  trigger:
    project: <path-to-project>
```

Specify the branch to use:

```yaml
job_name:
  trigger:
    project: <path-to-project>
    branch: main
```

---

## Parent-child pipelines

Child pipelines [](https://docs.gitlab.com/ee/ci/pipelines/parent_child_pipelines.html) are created from a file using `include`

`include` supports `local` [](https://docs.gitlab.com/ee/ci/yaml/#includelocal) for files in the same repository

Use `project`/`ref`/`file` [](https://docs.gitlab.com/ee/ci/yaml/#includeproject) for files in other repositories
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

See chapter [Triggers](/hands-on/2025-11-27/110_triggers/exercise/)

---

## Pro tip 1: Wait for downstream pipeline

Upstream pipeline only waits for successful trigger

Wait for successful downstream pipeline using `strategy` [](https://docs.gitlab.com/ee/ci/yaml/#triggerstrategy)

```yaml
job_name:
  trigger:
    include: child.yaml
    strategy: depend
```

Useful when triggering the pipeline of a dependency

---

```yaml
# parent pipeline
build_artifacts:
  stage: build
  script: echo "Content!" >> artifact.txt
  artifacts:
    paths:
    - artifact.txt

deploy:
  stage: deploy
  trigger:
    include:
    - local: path/to/child-pipeline.yml

# child pipeline
test:
  stage: test
  script: cat artifact.txt
  needs:
  - pipeline: $UPSTREAM_PIPELINE_ID
    job: build_artifacts
```

<!-- .element: style="float: right; font-size: 0.7em; height: 26em; width: 28em;" -->

## Pro tip 2: Artifacts from parent pipeline

Child pipeline fetches artifact from parent pipeline

This works for `dotenv` reports as well [](https://docs.gitlab.com/ee/ci/variables/#control-which-jobs-receive-dotenv-variables)

### Alternative

`needs:project` [](https://docs.gitlab.com/ee/ci/yaml/#needsproject)

Requires Premium subscription

See how-to [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html?tab=Multi-project+pipeline#fetch-artifacts-from-an-upstream-pipeline) and troubleshooting [](https://docs.gitlab.com/ee/ci/jobs/job_artifacts_troubleshooting.html#error-message-this-job-could-not-start-because-it-could-not-retrieve-the-needed-artifacts)

---

## Pro tip 3: Variable inheritence

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

## Pro tip 4: Do not pass global variables

Only allow job variables or specific global variables to be passed to downstream pipelines:

```yaml
variables:
  GLOBAL_VAR: value
  GLOBAL_VAR_2: value2

trigger-job-without-global-vars:
  inherit:
    variables: false
  trigger:
    include:
    - local: path/to/child-pipeline.yml

trigger-job-with-global-var:
  inherit:
    variables:
    - GLOBAL_VAR
  trigger:
    include:
    - local: path/to/child-pipeline.yml
```

---

## Pro tip 5: Types of variables to forward

Use `trigger:forward` [](https://docs.gitlab.com/ee/ci/yaml/#triggerforward) to define which types of variables to forward to downstream pipelines

- `yaml_variables` - variables defined in the trigger job
- `pipeline_variables` - variables passed to this pipeline [](https://docs.gitlab.com/ee/ci/variables/index.html#cicd-variable-precedence)

This only works for the direct downstream pipeline

---

## Pro tip 6: Permissions for include

When including a file from another project...

```yaml
job_name:
  trigger:
    include:
    - project: <path-to-project>
      ref: main
      file: <relative-path-to-file>
```

...the user must have the permission to run a pipeline in the other project

---

## Pro tip 7: Dynamic includes

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

## Example 1: Build, package, deploy

![](160_gitlab_ci/110_triggers/example1.drawio.svg) <!-- .element: style="width: 90%;" -->

---

## Example 2: Test, promote, deploy

![](160_gitlab_ci/110_triggers/example2.drawio.svg) <!-- .element: style="width: 75%;" -->
