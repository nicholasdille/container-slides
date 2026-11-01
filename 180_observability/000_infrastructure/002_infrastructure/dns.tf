data "hcloud_zone" "main" {
  provider = hcloud.dns
  name     = var.domain
}

resource "hcloud_zone_rrset" "k8s_host" {
  count = var.seat_count

  provider = hcloud.dns
  zone     = data.hcloud_zone.main.name
  name     = "seat${count.index}"
  type     = "A"
  ttl      = 120
  records = [
    { value = hcloud_server.k8s_host[count.index].ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "k8s_host_wildcard" {
  count = var.seat_count

  provider = hcloud.dns
  zone     = data.hcloud_zone.main.name
  name     = "*.seat${count.index}"
  type     = "CNAME"
  ttl      = 120
  records = [
    { value = hcloud_zone_rrset.k8s_host[count.index].name },
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

resource "local_file" "ssh_config_file_k8s_host" {
  count = var.seat_count

  content = templatefile("ssh_config.tpl", {
    node         = hcloud_server.k8s_host[count.index].name,
    node_ip      = hcloud_server.k8s_host[count.index].ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename        = pathexpand("~/.ssh/config.d/k8s${count.index}")
  file_permission = "0644"
}