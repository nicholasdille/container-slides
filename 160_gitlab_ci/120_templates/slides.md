<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

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
  script: pwd

job_name:
  extends: .template
  variables:
    bar: baz
```

<!-- .element: style="float: left; width: 25em;" -->

```yaml
job_name:
  image: alpine
  variables:
    foo: bar
    bar: baz
  script: pwd
```

<!-- .element: style="float: right; width: 25em;" -->

---

## Hands-On

See chapter [Templates](/hands-on/2024-11-12/120_templates/exercise/)

---

## Pro tip: Multiple inheritence

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

But `variables` are merged!

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

---

## Pro tip 3: Public Template Library

Project to help building professional pipelines [](https://to-be-continuous.gitlab.io/doc/)

Pipeline generator [](https://to-be-continuous.gitlab.io/kicker/)

Documentation [](https://to-be-continuous.gitlab.io/doc/intro/)

Source code [](https://gitlab.com/to-be-continuous)
