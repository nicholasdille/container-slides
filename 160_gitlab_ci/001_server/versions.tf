terraform {
  required_providers {
    gitlab = {
      # https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs
      source = "gitlabhq/gitlab"
      version = "17.6.1"
    }
    grafana = {
      # https://registry.terraform.io/providers/grafana/grafana/latest/docs
      source = "grafana/grafana"
      version = "3.13.2"
    }
  }
}