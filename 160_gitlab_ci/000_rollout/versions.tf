terraform {
  required_providers {
    hcloud = {
      # https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
      source = "hetznercloud/hcloud"
      version = "1.38.2"
    }
    hetznerdns = {
      # https://registry.terraform.io/providers/timohirt/hetznerdns/latest/docs
      source = "timohirt/hetznerdns"
      version = "2.2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    remote = {
      source = "tenstad/remote"
      version = "0.1.2"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "16.5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}