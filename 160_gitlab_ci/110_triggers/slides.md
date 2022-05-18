<!-- .slide: id="gitlab_triggers" class="vertical-center" -->

<i class="fa-duotone fa-play fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Triggers

---

## Trigger other pipelines

Ability to split automation

### Trigger tokens

Trigger pipelines using trigger tokens [](https://docs.gitlab.com/ee/ci/triggers/)

Fire and forget

### Multi-project pipelines

Links to downstream pipelines [](https://docs.gitlab.com/ee/ci/pipelines/multi_project_pipelines.html)

Use the `trigger` keyword [](https://docs.gitlab.com/ee/ci/yaml/index.html#trigger)

### Parent-child pipelines

Run additional stages and jobs from a file [](https://docs.gitlab.com/ee/ci/pipelines/parent_child_pipelines.html) using `include`

---

## Hands-On: Trigger tokens

1. Create a new project (anywhere!)
1. Add `trigger/.gitlab-ci.yml`
1. Go to **Settings** > **CI/CD** and unfold **Pipeline triggers**
1. Create a trigger
1. Copy curl snippet
1. Go back to previous project
1. Add new stage and job called `trigger`
1. Add curl snippet in `script` block
1. Store `TOKEN` as unprotected but masked CI variable [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_ci_variable)
1. Fill in `REF_NAME` with branch name (probably `main`)

(See new `.gitlab-ci.yml`)

---

## Hands-On: Multi-project pipelines

1. Replace `script` with `trigger` keyword
1. Specify project and branch:

    ```yaml
    job_name:
      trigger:
        project: foo/bar
        branch: baz
    ```

1. Check pipeline

---

## Hands-On: Parent-child pipelines

1. Add `parent/child/child.yml` to first project
1. Replace project and branch in `trigger` with `include` [<i class="fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_templates)

    ```yaml
    job_name:
      trigger:
        include: child.yml
    ```

Child pipeline can be made from multiple files

`include` supports `local` for files in the same repository

`project`/`ref`/`file` for files in other repositories
