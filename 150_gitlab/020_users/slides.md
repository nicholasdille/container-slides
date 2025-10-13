<!-- .slide: id="gitlab_users" class="vertical-center" -->

<i class="fa-duotone fa-users fa-8x" style="float: right; color: grey;"></i>

## Users

---

## Users

<i class="fa-duotone fa-user fa-4x" style="float: right;"></i>

GitLab maintains internal user object

No concept of user groups...

...only groups of projects with members

Users can be...

- Blocked/deactivated/banned/deleted
- Impersonated<br/>(logged in `/var/log/gitlab/gitlab-rails/application.log`)

### Hands-On

1. Create new user
1. Edit and reset password
1. Login with new user

---

## Membership

<i class="fa-duotone fa-id-badge fa-4x" style="float: right;"></i>

Users can be invited to join group and projects

Users can be assigned a role:

- Guest
- Reporter
- Developer
- Maintainer
- Owner

### Hands-On

1. Create another user
1. Create a group with one user
1. Invite the other user
