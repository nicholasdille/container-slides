<!-- .slide: id="gitlab_iac" class="vertical-center" -->

<i class="fa-duotone fa-network-wired fa-8x" style="float: right; color: grey;"></i>

## Infrastructure-as-Code

---

## Infrastructure-as-Code

<i class="fa-duotone fa-network-wired fa-4x" style="float: right;"></i>

GitLab can be configured using Terraform/OpenTofu

The official provider supports a long list of resource [](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs)
- Server configuration
- Group and project layout
- Project settings
- Authentication and authorization
- Integrations

For example, configure Grafana for monitoring GitLab [](https://github.com/nicholasdille/container-slides/blob/master/160_gitlab_ci/001_server/main.tf)

Remember GitLab-managed Terraform/OpenTofu state [](https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html)

Use `terraform-backend-git` for remote state [](https://github.com/plumber-cd/terraform-backend-git)
