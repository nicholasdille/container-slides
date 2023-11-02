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
  }
}