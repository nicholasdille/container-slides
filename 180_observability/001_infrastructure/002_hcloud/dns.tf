data "hcloud_zone" "main" {
  provider = hcloud.dns
  name     = var.domain
}

resource "hcloud_zone_rrset" "gitlab" {
  provider = hcloud.dns
  zone     = data.hcloud_zone.main.name
  name     = "gitlab"
  type     = "A"
  ttl      = 120
  records = [
    { value = hcloud_server.gitlab.ipv4_address },
  ]
}

resource "local_file" "ssh" {
  content         = tls_private_key.ssh_private_key.private_key_openssh
  filename        = pathexpand("~/.ssh/${var.event_name}_ssh")
  file_permission = "0600"
}

resource "local_file" "ssh_pub" {
  content         = tls_private_key.ssh_private_key.public_key_openssh
  filename        = pathexpand("~/.ssh/${var.event_name}_ssh.pub")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file_gitlab" {
  content = templatefile("ssh_config.tpl", {
    node         = hcloud_server.gitlab.name,
    node_ip      = hcloud_server.gitlab.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename        = pathexpand("~/.ssh/config.d/gitlab")
  file_permission = "0644"
}