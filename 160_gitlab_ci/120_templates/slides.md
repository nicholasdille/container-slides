<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

Templates contain required keywords

Templates must not be well-formed jobs

Job templates begin with a dot to prevent execution

Templates can be located in the same `.gitlab-ci.yml` (inline)

Templates can be imported using `include` [](https://docs.gitlab.com/ee/ci/yaml/#include) from...

- Files in the same repository
- Files in other repositories of the same instance
- Remote locations (only unauthenticated)

See also the official development guide for templates [](https://docs.gitlab.com/ee/development/cicd/templates.html)

---

## Templates 1/

Keywords from `job_name` are applied after keywords from `.template`

The following pipeline... results in the following job:

```yaml
.template:
  image: alpine
  script: pwd

job_name:
  extends: .template
```

<!-- .element: style="float: left; width: 25em;" -->

```yaml
job_name:
  image: alpine
  script: pwd
```

<!-- .element: style="float: right; width: 25em;" -->

---

## Templates 2/

Keywords from `job_name` are applied after keywords from `.template`

The following pipeline... result in the following job:

```yaml
.template:
  image: alpine
  script: pwd

job_name:
  extends: .template
  script: ls -l
```

<!-- .element: style="float: left; width: 25em;" -->

```yaml
job_name:
  image: alpine
  script: ls -l
```

<!-- .element: style="float: right; width: 25em;" -->

---

## Templates 3/3

Variables are merged!

The following pipeline... result in the following job:

```yaml
.template:
  image: alpine
  variables:
    foo: bar
    my_var: my_val
  script: pwd

job_name:
  extends: .template
  variables:
    bar: baz
    my_var: also_my_val
```

<!-- .element: style="float: left; width: 25em;" -->

```yaml
job_name:
  image: alpine
  variables:
    foo: bar
    bar: baz
    my_var: also_my_val
  script: pwd
```

<!-- .element: style="float: right; width: 25em;" -->

---

## Hands-On: Templates

Go to [exercises](/hands-on/2025-11-27/120_templates/exercise/)

---

## Pro tip 1: Multiple inheritence

Jobs can inherit from multiple templates

```yaml
job_name:
  extends:
  - .template1
  - .template2
```

With conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...last writer wins!

```yaml
job_name:
  script: whoami
```

---

## Pro tip 2: Solve multiple inheritence

Conflicting templates...

```yaml
.template1:
  script: pwd
.template2:
  script: whoami
```

...can be resolved by using reference tags [](https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#reference-tags)

```yaml
job_name:
  script:
  - !reference[.template1, script]
  - !reference[.template2, script]
```

CI/CD Components [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_components) and CI/CD Steps [<i class="fa fa-solid fa-arrow-right-to-bracket"></i>](#/gitlab_steps) are a proper solution in a later chapter

---

## Pro tip 3: Organizing templates in repositories

Once you are hooked on templates, you want to organize them in a repository

### Versioning

Use tags and releases to mark versions

### Single repository

Easy to find/browse, hard to version

Apply separate versioning: docker/v1.0.0, helm/v1.0.2, k8s/v1.2.0

### Repository per topic

Separation of concerns

Harder to find/browse, easier to version

---

## Pro tip 4: Public Template Library

Project *to be continuous* [](https://to-be-continuous.gitlab.io/doc/) to help building professional pipelines

Pipeline generator [](https://to-be-continuous.gitlab.io/kicker/)

Well documented [](https://to-be-continuous.gitlab.io/doc/intro/)

Source code on GitLab.com [](https://gitlab.com/to-be-continuous)
