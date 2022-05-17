<!-- .slide: id="gitlab_script_blocks" class="vertical-center" -->

<i class="fa-duotone fa-file-code fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Script blocks

---

## Script blocks

`script` represents the core steps performed by a job

`script` is just a YAML string

GitLab also supported YAML herestrings [](https://yaml-multiline.info/):

```yaml
job_name:
  script: |
    pwd
    whoami
    printenv
```

Some jobs require preparation and cleanup to work correctly

```yaml
job_name:
  before_script: echo before_script
  script: echo core
  after_script: echo after_script
```

---

## Hands-On

Separate `script` into...

- Preparation
- Core steps
- Cleanup

Move `apk` operations into `before_script`

(See `.gitlab-ci.yml`)

(Yes, this is still repetetive <i class="fa-duotone fa-face-smile-tongue fa-duotone-colors"></i>)
