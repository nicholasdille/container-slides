<!-- .slide: id="gitlab_authentication" class="vertical-center" -->

<i class="fa-duotone fa-key-skeleton-left-right fa-8x" style="float: right; color: grey;"></i>

## Authentication

---

## Personal Credentials

<i class="fa-duotone fa-key-skeleton fa-4x" style="float: right;"></i>

We have already used username and password

Users can create [Personal Access Tokens](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html)

- Used instead of password for `git` operations
- Used to access the API (more later)

Users can add [SSH public keys](https://docs.gitlab.com/ee/user/ssh.html)

- Used for `git` operations

Permissions inherited from user

### Hands-On

1. Create a personal access token
1. (Optionally) Clone a repository using the PAT instead of the password

---

## Group and Project Credentials 1/2

![](150_gitlab/030_authentication/options.drawio.svg) <!-- .element: style="width: 100%;" -->

---

## Group and Project Credentials 2/2

<i class="fa-duotone fa-id-card-clip fa-4x" style="float: right;"></i>

### Scoped to group

Configurable [Group Access Tokens](https://docs.gitlab.com/ee/user/group/settings/group_access_tokens.html)

Read-only [Group Deploy Tokens](https://docs.gitlab.com/ee/user/project/deploy_tokens/)

### Scoped to project

Configurable [Project Access Tokens](https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html)

Read-only [Project Deploy Token](https://docs.gitlab.com/ee/user/project/deploy_tokens/)

Read-write [Project Deploy SSH Key](https://docs.gitlab.com/ee/user/project/deploy_keys/)

### Hands-On

1. Create a project deploy token
1. (Optionally) Use it to clone the repository

---

## Caveats 1/

### Token creation can be tricky

Role defines the permission level

Scope specifies available "features", e.g.

- `(read_)?api`
- `(read|write)_repository`
- `create_runner` ([more](#/gitlab_runner) later)

Expiration defines how long

### Example

Role: Developer

Scope: `read_repository`

User can pull but not push

---

## Caveats 2/2

Deploy keys belong to a user who can be blocked <i class="fa fa-solid fa-face-scream"></i> [gitlab-org/gitlab#35779](https://gitlab.com/gitlab-org/gitlab/-/issues/35779)

Find and fix deploy keys [using Ruby code in rails console](https://docs.gitlab.com/ee/user/project/deploy_keys/#identify-deploy-keys-associated-with-non-member-and-blocked-users)

```ruby
DeployKeysProject.with_write_access.find_each do |deploy_key_mapping|
  project = deploy_key_mapping.project
  deploy_key = deploy_key_mapping.deploy_key
  user = deploy_key.user

  access_checker = Gitlab::DeployKeyAccess.new(deploy_key, container: project)
  can_push = access_checker.can_do_action?(:push_code)
  can_push_to_default = access_checker.can_push_for_ref?(project.repository.root_ref)

  next if access_checker.allowed? && can_push && can_push_to_default

  puts "Deploy key: #{deploy_key.id}, Project: #{project.full_path}, Can push?: " + (can_push ? 'YES' : 'NO') +
       ", Can push to default branch #{project.repository.root_ref}?: " + (can_push_to_default ? 'YES' : 'NO') +
       ", User: #{user.username}, User ID: #{user.id}, User state: #{user.state}"
end
```

<!-- .element: style="height: 18em;" -->

---

## Comparison

| | Password | Personal Access Token | Personal SSH Key | Group Access Token | Group Deploy Token | Project Access Token | Project Deploy Token | Project Deploy Key (SSH) |
|-|-|-|-|-|-|-|-|-|
| Access to Web UI            | Yes          | No      | No       | No          | No          | No      | No      | No          |
| Access to API               | Indirect (1) | Yes     | No       | Yes (2)     | No          | Yes (3) | No      | No          |
| Read git repository         | Yes          | Yes     | Yes      | Yes         | Yes         | Yes     | Yes     | Yes         |
| Write git repository        | Yes          | Yes     | Yes      | Yes         | No          | Yes     | No      | No          |
| Access CI variables         | Yes          | Yes (4) | No       | Yes (4)     | No          | Yes (4) | No      | No          |
| Access scope                | User         | User    | User     | Group       | Group       | Project | Project | Project     |
| Employee layoffs            | Yes          | Yes     | Yes      | No          | No          | No      | No      | Yes         |
| Credential reuse (5)        | Possible     | No      | Possible | No          | No          | No      | No      | Possible    |
| Impact of security incident | High         | High    | High     | Medium      | Medium      | Low     | Low     | Medium      |
| Recommendation              | No           | No      | No       | Limited (6) | Limited (6) | Yes     | Yes     | Limited (6) |

<!-- .element: style="font-size: 0.4em;" -->

- (1) Username and password can be used to retrieve a personal access token
- (2) Group only
- (3) Project only
- (4) API only
- (5) Can be used for multiple accounts and on multiple systems
- (6) Acceptable for automation to avoid many project credentials

<!-- .element: style="font-size: smaller;" -->
