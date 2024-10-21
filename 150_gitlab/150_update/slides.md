<!-- .slide: id="gitlab_update" class="vertical-center" -->

<i class="fa-duotone fa-rotate fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Update

---

## Update

<i class="fa-duotone fa-rotate fa-4x fa-duotone-colors" style="float: right;"></i>

GitLab releases regularly [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://about.gitlab.com/releases/categories/releases/)

New minor version on the 22th every month

New major version every May

Several patches and security fixes per month

See changelog [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://gitlab.com/gitlab-org/gitlab/-/blob/master/CHANGELOG.md)

Check for update in admin area (Menu <i class="fa-regular fa-arrow-right"></i> Admin)

Upcoming releases by version [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://about.gitlab.com/upcoming-releases/) and by product tier [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://about.gitlab.com/direction/paid_tiers/)

Deprecations are documented [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/update/deprecations)

Make sure you have a backup [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/raketasks/backup_restore.html)

You must update to every minor version due to schema updates

---

## Hands-On

1. Update `compose.yml` in 100_reverse_proxy<br>with new image `gitlab/gitlab-ee:17.5.1-ee.0`
1. Run deployment from [reverse proxy section](#/gitlab_traefik)

(Minor update to v16.10.0 possible.)
