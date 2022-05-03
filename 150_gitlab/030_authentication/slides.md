<!-- .slide: id="gitlab_authentication" class="vertical-center" -->

<i class="fa-duotone fa-key-skeleton-left-right fa-8x fa-duotone-colors" style="float: right; color: grey;"></i>

## Authentication

---

## Personal Credentials

<i class="fa-duotone fa-key-skeleton fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

We have already used username and password

Users can create *Personal Access Tokens*

- Used instead of password for `git` operations
- Used to access the API (more later)

Users can add SSH public keys

- Used for `git` operations

Permissions inherited from user

### Hands-On

1. Create a PAT
1. Clone a repository using the PAT instead of the password

---

## Group and Project Credentials

<i class="fa-duotone fa-bucket fa-4x fa-duotone-colors-inverted" style="float: right;"></i>

### Scoped to group

Group Deploy Tokens (read only)

Group Access Tokens (configurable)

### Scoped to project

Project Access Tokens (configurable)

Project Deploy Token (read-only)

Project Deploy SSH Key (read-write)

### Hands-On

1. Create a project deploy token
1. Use it to clone the repository
