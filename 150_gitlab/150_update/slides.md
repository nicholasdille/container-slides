<!-- .slide: id="gitlab_update" class="vertical-center" -->

<i class="fa-duotone fa-rotate fa-8x" style="float: right; color: grey;"></i>

## Update

---

## Update

<i class="fa-duotone fa-rotate fa-4x" style="float: right;"></i>

GitLab [releases regularly](https://about.gitlab.com/releases/categories/releases/)

New minor version on the 22th every month

New major version every May

Several patches and security fixes per month

See [changelog](https://gitlab.com/gitlab-org/gitlab/-/blob/master/CHANGELOG.md)

Check for update in admin area (Menu <i class="fa-regular fa-arrow-right"></i> Admin)

Upcoming releases [by version](https://about.gitlab.com/upcoming-releases/) and [by product tier](https://about.gitlab.com/direction/paid_tiers/)

[Deprecations](https://docs.gitlab.com/ee/update/deprecations) are documented

Make sure you have a [backup](https://docs.gitlab.com/ee/raketasks/backup_restore.html)

For upgrades from older versions, checkout the [upgrade path tool](https://gitlab-com.gitlab.io/support/toolbox/upgrade-path/)

---

## Preparation for Update

Run upgrade health checks [](https://docs.gitlab.com/update/plan_your_upgrade/#run-upgrade-health-checks)

```bash
gitlab-rake gitlab:check
```

Pause pipelines [](https://docs.gitlab.com/update/plan_your_upgrade/#pause-cicd-pipelines-and-jobs)

```bash
nginx['custom_gitlab_server_config'] = "location = /api/v4/jobs/request {\n deny all;\n return 503;\n}\n"
```

Then reconfigure GitLab:

```bash
gitlab-ctl reconfigure
```

---

## Hands-On

### Option 1: Docker

1. Update `compose.yml` in `100_reverse_proxy`<br>with new image `gitlab/gitlab-ee:18.5.1-ee.0`: 

    ```bash
    vim ../100_reverse_proxy/compose.yml
    ```
    
1. Run deployment from [reverse proxy section](#/gitlab_traefik)

### Option 2: Package manager

Update according to official documentation [](https://docs.gitlab.com/update/package/)

```bash
apt-get update
apt-get install -y gitlab-ee=18.5.1-ee.0
```
