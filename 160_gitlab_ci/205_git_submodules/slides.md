<!-- .slide: id="gitlab_git_submodules" class="vertical-center" -->

<i class="fa-duotone fa-folder-tree fa-8x fa-duotone-colors-inverted" style="float: right; color: grey;"></i>

## Git Submodules

---

## Git Submodules

Handling of submodules is supported [](https://docs.gitlab.com/ee/ci/git_submodules.html)

Submodules are not fetched automatically

...because `GIT_SUBMODULE_STRATEGY` defaults to `none`

Enable handling of submodules:

```yaml
job_name:
  variables:
    GIT_SUBMODULE_STRATEGY: normal
```

Recursive fetching is supported with `GIT_SUBMODULE_STRATEGY=recursive`

---

## Authentication for Git Submodules

### Same GitLab instance

Absolute and relative paths are supported

Mind the permissions of `CI_JOB_TOKEN` (!)

### Use HTTP(S) instead of SSH

```yaml
job_name:
  variables:
    GIT_SUBMODULE_STRATEGY: none
  script:
  - |
    git config --global \
        url."https://gitlab.inmylab.de/".insteadOf "ssh://git@gitlab.inmylab.de/"
```

### Alternative

Use `ssh-agent` on GitLab runner machine
