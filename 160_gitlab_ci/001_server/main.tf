provider "gitlab" {
  base_url = "https://gitlab.${local.domain}/api/v4/"
  token = var.gitlab_token
}

provider "grafana" {
  url = "https://grafana.${local.domain}"
  auth = "admin:${local.grafana_password}"
}

resource "gitlab_application_settings" "settings" {
  auto_devops_enabled = false
  default_group_visibility = "internal"
  default_project_visibility = "internal"
  restricted_visibility_levels = ["public"]
  first_day_of_week = 1
  require_personal_access_token_expiry = true
  signup_enabled = false
  #terms = ""
  usage_ping_enabled = false
}

resource "gitlab_application" "grafana" {
  confidential = true
  scopes       = ["openid", "email", "profile"]
  name         = "grafana"
  #redirect_url = "https://grafana.${local.domain}/login/gitlab"
  redirect_url = "https://grafana.${local.domain}/login/generic_oauth"
}

resource "grafana_sso_settings" "gitlab" {
  #provider_name = "gitlab"
  provider_name = "generic_oauth"
  oauth2_settings {
    name                  = "Gitlab"
    auth_url              = "https://gitlab.${local.domain}/oauth/authorize"
    token_url             = "https://gitlab.${local.domain}/oauth/token"
    api_url               = "https://gitlab.${local.domain}/api/v4"
    client_id             = gitlab_application.grafana.application_id
    client_secret         = gitlab_application.grafana.secret
    allow_sign_up         = true
    allow_assign_grafana_admin = true
    auto_login            = false
    scopes                = "openid email profile"
    org_mapping           = "root:*:Admin,*:*:Viewer"
    org_attribute_path    = "info.roles"
    use_refresh_token     = true
  }
}

resource "grafana_data_source" "gitlab" {
  type       = "prometheus"
  name       = "GitLab Omnibus"
  url        = "http://gitlab:9090"
  is_default = true
}

data "http" "gitlab_overview" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/overview.json"
}

data "http" "gitlab_gitaly" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/gitaly.json"
}

data "http" "gitlab_nginx" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/nginx.json"
}

data "http" "gitlab_postgresql" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/postgresql.json"
}

data "http" "gitlab_rails" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/rails-app.json"
}

data "http" "gitlab_redis" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/redis.json"
}

data "http" "gitlab_registry" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/registry.json"
}

data "http" "gitlab_platform" {
  url = "https://gitlab.com/gitlab-org/grafana-dashboards/-/raw/master/omnibus/service_platform_metrics.json"
}

resource "grafana_dashboard" "gitlab_overview" {
  config_json = data.http.gitlab_overview.response_body
}

resource "grafana_dashboard" "gitlab_gitaly" {
  config_json = data.http.gitlab_gitaly.response_body
}

resource "grafana_dashboard" "gitlab_nginx" {
  config_json = data.http.gitlab_nginx.response_body
}

resource "grafana_dashboard" "gitlab_postgresql" {
  config_json = data.http.gitlab_postgresql.response_body
}

resource "grafana_dashboard" "gitlab_rails" {
  config_json = data.http.gitlab_rails.response_body
}

resource "grafana_dashboard" "gitlab_redis" {
  config_json = data.http.gitlab_redis.response_body
}

resource "grafana_dashboard" "gitlab_registry" {
  config_json = data.http.gitlab_registry.response_body
}

resource "grafana_dashboard" "gitlab_platform" {
  config_json = data.http.gitlab_platform.response_body
}

resource "gitlab_user" "seats" {
  count = var.user_count

  name              = "seat${count.index}"
  username          = "seat${count.index}"
  password          = local.seats_password[count.index]
  email             = "seat${count.index}@inmylab.de"
  can_create_group  = true
  is_external       = false
  reset_password    = false
  skip_confirmation = true
}

resource "gitlab_personal_access_token" "seats_vscode" {
  count = var.user_count

  user_id    = gitlab_user.seats[count.index].id
  name       = "vscode"

  scopes = ["api", "read_user", "write_repository"]
}

resource "gitlab_project" "seats_demo" {
  count = var.user_count

  name        = "demo"
  description = "Demo"
  namespace_id = gitlab_user.seats[count.index].namespace_id

  visibility_level = "internal"

  default_branch = "main"
  initialize_with_readme = true
}

resource "gitlab_user_runner" "shared" {
  runner_type = "instance_type"

  description = "Shared runner"
  tag_list    = []
  untagged    = true
}