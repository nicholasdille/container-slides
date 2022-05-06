<!-- .slide: id="gitlab_maintenance" class="vertical-center" -->

<i class="fa-duotone fa-triangle-person-digging fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Maintenance

---

## Maintenance

<i class="fa-duotone fa-triangle-exclamation fa-4x fa-duotone-colors" style="float: right;"></i>

### Messages

Show a banner announcing maintenance work

Configure under Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Messages

### Maintenance Mode

Switch GitLab into read-only mode [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/maintenance_mode/)

---

## Repository maintenance

<i class="fa-brands fa-git-alt fa-4x" style="float: right;"></i>

Runs `git fsck` to find silent disk corruption

Incremental `git repack` after 10 pushes

Full `git repack` after 50 pushes

`git gc` after 200 pushes
