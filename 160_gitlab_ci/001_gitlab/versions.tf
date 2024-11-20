terraform {
  required_providers {
    gitlab = {
      # https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs
      source = "gitlabhq/gitlab"
      version = "17.5.0"
    }
  }
}