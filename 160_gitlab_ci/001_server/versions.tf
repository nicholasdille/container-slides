terraform {
  required_providers {
    gitlab = {
      # https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs
      source = "gitlabhq/gitlab"
      version = "17.11.0"
    }
    grafana = {
      # https://registry.terraform.io/providers/grafana/grafana/latest/docs
      source = "grafana/grafana"
      version = "3.24.1"
    }
  }
}