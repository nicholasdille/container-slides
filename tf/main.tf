provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

resource "tls_private_key" "demo" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "demo" {
  name       = "demo"
  public_key = tls_private_key.demo.public_key_openssh
}

data "hcloud_image" "demo" {
  with_selector = "type=uniget"
  most_recent = true
}

resource "hcloud_server" "demo" {
  name        = "demo"
  location    = "nbg1"
  server_type = "cx41"
  image       = data.hcloud_image.demo.id
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
  user_data = <<EOF
grep security /etc/apt/sources.list >/etc/apt/sources.list.d/security.list
apt-get update -o Dir::Etc::SourceList=/etc/apt/false -o Dir::Etc::SourceParts=/etc/apt/sources.list.d
apt-get upgrade -y
rm -f /etc/apt/sources.list.d/security.list
EOF
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

resource "local_file" "ssh" {
  content = tls_private_key.demo.private_key_openssh
  filename = pathexpand("~/.ssh/demo_ssh")
  file_permission = "0600"
}

resource "local_file" "ssh_pub" {
  content = tls_private_key.demo.public_key_openssh
  filename = pathexpand("~/.ssh/demo_ssh.pub")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file" {
  content = templatefile("ssh_config.tpl", {
    node = "demo",
    node_ip = hcloud_server.demo.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/demo")
  file_permission = "0644"
}