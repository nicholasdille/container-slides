resource "gitlab_application_settings" "settings" {
  auto_devops_enabled                     = false
  default_group_visibility                = "internal"
  default_project_visibility              = "internal"
  restricted_visibility_levels            = ["public"]
  first_day_of_week                       = 1
  require_personal_access_token_expiry    = true
  signup_enabled                          = false
  usage_ping_enabled                      = false
  snowplow_enabled                        = false
  password_authentication_enabled_for_git = true
  password_authentication_enabled_for_web = true
  require_admin_two_factor_authentication = false
  require_two_factor_authentication       = false
  two_factor_grace_period                 = 48
  enforce_terms                           = false
  terms                                   = ""
  whats_new_variant                       = "disabled"
  hide_third_party_offers                 = true
  grafana_url                             = "https://grafana.${local.domain}"
}

resource "gitlab_application" "grafana" {
  confidential = true
  scopes       = ["openid", "email", "profile"]
  name         = "grafana"
  redirect_url = "https://grafana.${local.domain}/login/generic_oauth"
}

resource "grafana_sso_settings" "gitlab" {
  provider_name = "generic_oauth"
  oauth2_settings {
    name                       = "Gitlab"
    auth_url                   = "https://gitlab.${local.domain}/oauth/authorize"
    token_url                  = "https://gitlab.${local.domain}/oauth/token"
    api_url                    = "https://gitlab.${local.domain}/api/v4"
    client_id                  = gitlab_application.grafana.application_id
    client_secret              = gitlab_application.grafana.secret
    allow_sign_up              = true
    allow_assign_grafana_admin = true
    auto_login                 = false
    scopes                     = "openid email profile"
    use_refresh_token          = true
    role_attribute_path        = "contains(groups_direct[*], 'grafana') && 'GrafanaAdmin' || 'Viewer'"
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

resource "grafana_dashboard" "gitlab_ci" {
  config_json = file("dashboard.json")
}

resource "gitlab_group" "grafana" {
  name             = "Grafana"
  path             = "grafana"
  visibility_level = "private"
}

# https://gitlab.com/gitlab-org/cli/#oauth-gitlab-self-managed-gitlab-dedicated
resource "gitlab_application" "glab" {
  name         = "glab"
  scopes       = ["openid", "email", "read_user", "write_repository", "api"]
  confidential = false
  redirect_url = "http://localhost:7171/auth/redirect"
}

# https://github.com/hickford/git-credential-oauth?tab=readme-ov-file#gitlab
resource "gitlab_application" "git_credential_oauth" {
  name         = "git-credential-oauth"
  scopes       = ["read_repository", "write_repository"]
  confidential = false
  redirect_url = "http://127.0.0.1"
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
  projects_limit    = 100
}

resource "gitlab_personal_access_token" "seats_vscode" {
  count = var.user_count

  user_id = gitlab_user.seats[count.index].id
  name    = "vscode"

  scopes = ["api", "read_user", "write_repository"]
}

resource "gitlab_project" "seats_demo" {
  count = var.user_count

  name         = "demo"
  description  = "Demo"
  namespace_id = gitlab_user.seats[count.index].namespace_id

  visibility_level = "internal"

  default_branch         = "main"
  initialize_with_readme = true
}

resource "gitlab_project_variable" "user_seat_n" {
  count = var.user_count

  project = gitlab_project.seats_demo[count.index].id

  description       = "Your personal seat index (the N in seatN)"
  key               = "SEAT_INDEX"
  value             = count.index
  variable_type     = "env_var"
  environment_scope = "*"

  raw       = true
  protected = false
  masked    = false
}

resource "gitlab_user_runner" "shared" {
  runner_type = "instance_type"

  description = "Shared runner"
  tag_list    = []
  untagged    = true
}