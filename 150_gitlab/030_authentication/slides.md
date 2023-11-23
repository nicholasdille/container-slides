<!-- .slide: id="gitlab_authentication" class="vertical-center" -->

<i class="fa-duotone fa-key-skeleton-left-right fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Authentication

---

## Personal Credentials

<i class="fa-duotone fa-key-skeleton fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

We have already used username and password

Users can create *Personal Access Tokens* [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)

- Used instead of password for `git` operations
- Used to access the API (more later)

Users can add SSH public keys [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/ssh.html)

- Used for `git` operations

Permissions inherited from user

### Hands-On

1. Create a personal access token
1. Clone a repository using the PAT instead of the password

---

## Group and Project Credentials

<i class="fa-duotone fa-id-card-clip fa-4x fa-duotone-colors" style="float: right;"></i>

### Scoped to group

Group Deploy Tokens (read only) [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/project/deploy_tokens/)

Group Access Tokens (configurable) [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/group/settings/group_access_tokens.html)

### Scoped to project

Project Access Tokens (configurable) [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)

Project Deploy Token (read-only) [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/project/deploy_tokens/)

Project Deploy SSH Key (read-write) [<i class="fa-solid fa-arrow-up-right-from-square"></i>](https://docs.gitlab.com/ee/user/project/deploy_keys/)

### Hands-On

1. Create a project deploy token
1. Use it to clone the repository

---

## Caveats

### Token creation can be tricky

Role defines the permission level

Scope specified available "features", e.g.

- `(read_)?api`
- `(read|write)_repository`
- `create_runner` ([more](#/gitlab_runner) later)

Expiration defines how long

### Example

Role: Developer

Scope: `read_repository`

User can pull but not push
