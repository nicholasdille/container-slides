terraform {
  required_providers {
    hcloud = {
      # https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
      source = "hetznercloud/hcloud"
      version = "1.48.1"
    }
    hetznerdns = {
      # https://registry.terraform.io/providers/timohirt/hetznerdns/latest/docs
      source = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.26.0"
    }
    remote = {
      source = "tenstad/remote"
      version = "0.1.3"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.7.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "17.4.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.3"
    }
  }
}