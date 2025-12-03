terraform {
  required_providers {
    gitlab = {
      # https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs
      source  = "gitlabhq/gitlab"
      version = "18.6.1"
    }
    grafana = {
      # https://registry.terraform.io/providers/grafana/grafana/latest/docs
      source  = "grafana/grafana"
      version = "4.21.0"
    }
  }
}

provider "gitlab" {
  base_url = "https://gitlab.${local.domain}/api/v4/"
  token    = var.gitlab_token
}

provider "grafana" {
  url  = "https://grafana.${local.domain}"
  auth = "admin:${local.grafana_password}"
}