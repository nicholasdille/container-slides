provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

resource "hcloud_ssh_key" "demo" {
  name       = "demo"
  public_key = file("./ssh.pub")
}

resource "hcloud_server" "demo" {
  name        = "demo"
  location    = "nbg1"
  server_type = "cx41"
  image       = "ubuntu-22.04"
  ssh_keys    = [
    hcloud_ssh_key.demo.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : "demo"
  }
}

data "hetznerdns_zone" "inmylab" {
  name = "inmylab.de"
}

resource "hetznerdns_record" "demo" {
  zone_id = data.hetznerdns_zone.inmylab.id
  name = "demo"
  value = hcloud_server.demo.ipv4_address
  type = "A"
  ttl= 120
}

resource "hetznerdns_record" "wildcard-demo" {
  zone_id = data.hetznerdns_zone.inmylab.id
  name = "*.demo"
  value = hetznerdns_record.demo.name
  type = "CNAME"
  ttl= 120
}