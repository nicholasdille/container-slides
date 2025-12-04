<!-- .slide: id="gitlab_permissions" class="vertical-center" -->

<i class="fa-duotone fa-user-police-tie fa-8x" style="float: right; color: grey;"></i>

## Roles and permissions

---

## Roles 1/2

Builtin roles [](https://docs.gitlab.com/user/permissions/#roles)

| Role       | Purpose                                          |
|------------|--------------------------------------------------|
| Guest      | Read-only access                                 |
| Planner    | Project management                               |
| Reporter   | Report and work on issues                        |
| Developer  | Create code and use pipelines                    |
| Maintainer | Manage pipelines, deployments and merge requests |
| Owner      | Configuration, Permissions                       |

Guest < Planner < Reporter < Developer < Maintainer < Owner

Auditor users [](https://docs.gitlab.com/administration/auditor_users/) with global read-only in GitLab Premium

Custom roles [](https://docs.gitlab.com/user/custom_roles/) are only available in GitLab Ultimate

---

## Roles 2/2

Roles can be assigned...

- to users
- to groups
- with an expiration date

### Inheritance

Roles are propagated to subgroups and projects

Subgroups and projects can (only) increase the role

### Permissions

Detailed permissions [](https://docs.gitlab.com/ee/user/permissions.html) are documented
