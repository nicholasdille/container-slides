<!-- .slide: id="gitlab_directories" class="vertical-center" -->

<i class="fa-duotone fa-folder-tree fa-8x" style="float: right; color: grey;"></i>

## Directory layout<br>and Logs

---

## Directory layout

<i class="fa-duotone fa-folder-tree fa-4x" style="float: right;"></i>

GitLab uses a clean top level directory layout

### Configuration

`/etc/gitlab`

Generated from `$GITLAB_OMNIBUS_CONFIG`

### Runtime data

`/var/opt/gitlab`

### Logs

`/var/log/gitlab`

---

## Repositories

Repositories are located in 

`/var/opt/gitlab/git-data/repositories/@hashed`

Subdirectories are hashes like

`ab/cd/abcdefg0123456789.git`

Hashes for repositories can be looked up in the admin area

Repository info for a hash can be found in...

```
/var/opt/gitlab
  /git-data/repositories/
    @hashed/ab/cd/abcdef0123456789.git
        /config
```

Hashed are generated from project ID:

```
echo -n "${CI_PROJECT_ID}" | sha256sum
```

---

## Logs

<i class="fa-duotone fa-align-left fa-4x" style="float: right;"></i>

Logs are located in `/var/log/gitlab`

Subdirectory per service

### Important log files

GitLab Workhorse: `/var/log/gitlab/gitlab-workhorse/current`

GitLab Rails: `/var/log/gitlab/gitlab-rails/*.log`

Gitaly: `/var/log/gitlab/gitaly/current`

Sidekiq: `/var/log/gitlab/sidekiq/current`
