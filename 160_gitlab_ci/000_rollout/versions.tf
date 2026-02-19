terraform {
  required_providers {
    hcloud = {
      # https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs
      source  = "hetznercloud/hcloud"
      version = "1.57.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.45.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.2.1"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

provider "hcloud" {
  alias = "default"
  token = var.hcloud_token
}

provider "hcloud" {
  alias = "dns"
  token = var.hcloud_dns_token
}

provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
