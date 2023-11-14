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

## Hands-On: Trigger tokens [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/110_triggers/curl "110_trigger/curl")

1. Create a new project (anywhere!)
1. Add `trigger/.gitlab-ci.yml` to root of new project 
1. **Optionally, jump to next demo/slide**
1. Go to **Settings** > **CI/CD** and unfold **Pipeline triggers**
1. Create a trigger and copy `curl` snippet
1. Go back to previous project
1. Switch to branch `main`
1. Add new stage and job called `trigger`
1. Add `curl` snippet in `script` block
1. Store `TOKEN` as unprotected but masked CI variable [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_ci_variable)
1. Fill in `REF_NAME` with branch name (`main`)

See new `.gitlab-ci.yml`:

```bash
git checkout origin/160_gitlab_ci/110_triggers/curl -- '*'
```

---

## Heads-up

### Visibility of trigger tokens

Users sees only their own tokens

Tokens of other users are hidden

### Branch protection can prevent triggers

Trigger owner must be able to either...

- Push to a branch
- Merge into a branch

---

## Hands-On: Multi-project pipelines

1. Replace `script` with `trigger` keyword
1. Specify project and branch:

    ```yaml
    job_name:
      trigger:
        project: foo/bar
        branch: main
    ```

1. Check pipeline

---

## Hands-On: Parent-child pipelines [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/tree/160_gitlab_ci/110_triggers/parent-child "110_triggers/parent-child")

1. Add `parent-child/child.yml` to root of first project
1. Replace `project` and `branch` under `trigger` with `include` [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_templates)

    ```yaml
    job_name:
      trigger:
        include: child.yml
    ```

Child pipeline can be made from multiple files

`include` supports `local` for files in the same repository

Use `project`/`ref`/`file` for files in other repositories

Included file can also be generated before job start [](https://docs.gitlab.com/ee/ci/pipelines/downstream_pipelines.html#dynamic-child-pipelines)

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
    include: child.ymal
    strategy: depend
```

---

## Dynamic includes

Include can be generated on-demand:

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
