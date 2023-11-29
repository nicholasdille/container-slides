<!-- .slide: id="gitlab_templates" class="vertical-center" -->

<i class="fa-duotone fa-book-sparkles fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Templates

---

## Make jobs reusable

Job templates begin with a dot to prevent execution

Templates can be located in the same `.gitlab-ci.yml` (inline)

Templates can be imported using `include` [](https://docs.gitlab.com/ee/ci/yaml/#include) from...

- Files in the same repository
- Files in other repositories of the same instance
- Remote locations (only unauthenticated)

See also the official development guide for templates [](https://docs.gitlab.com/ee/development/cicd/templates.html)

---

## Hands-On

See chapter [Templates](/hands-on/20231130/120_templates/exercise/)

### Template and include

### Local

### File

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
