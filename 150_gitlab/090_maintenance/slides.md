<!-- .slide: id="gitlab_maintenance" class="vertical-center" -->

<i class="fa-duotone fa-triangle-person-digging fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Maintenance

---

## Maintenance

<i class="fa-duotone fa-triangle-exclamation fa-4x fa-duotone-colors" style="float: right;"></i>

### Messages

Show a banner announcing maintenance work [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/broadcast_messages.html)

Configure under Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Messages

Can also show up in git response

### Maintenance Mode (Premium feature)

Switch GitLab into read-only mode [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/administration/maintenance_mode/)

---

## Repository maintenance

<i class="fa-brands fa-git-alt fa-4x" style="float: right;"></i>

Automatically optimize git repositories [](https://docs.gitlab.com/ee/administration/housekeeping.html), especially...
- Compress objects and revisions
- Remove unreachable objects

Configure under Menu <i class="fa-regular fa-arrow-right"></i> Admin <i class="fa-regular fa-arrow-right"></i> Settings <i class="fa-regular fa-arrow-right"></i> Repository <i class="fa-regular fa-arrow-right"></i> Repository Maintenance
- Enable repository checks (default)
- Enable housekeeping (default)
- Configure optimization period (default: 10 pushes)
