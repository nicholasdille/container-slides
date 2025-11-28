<!-- .slide: id="gitlab_script_blocks" class="vertical-center" -->

<i class="fa-duotone fa-file-code fa-8x" style="float: right; color: grey;"></i>

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

`after_script` runs even if the job failed or was canceled (useful for cleanup)

---

## Hands-On

See chapter [Scriptblocks](/hands-on/2025-11-27/030_script_blocks/exercise/)
