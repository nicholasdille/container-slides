resource "tls_private_key" "ssh_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
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
  count = var.create_dns ? var.seat_count : 0

  content = templatefile("ssh_config.tpl", {
    node         = hcloud_server.k8s_host[count.index].name,
    node_ip      = hcloud_server.k8s_host[count.index].ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename        = pathexpand("~/.ssh/config.d/k8s${count.index}")
  file_permission = "0644"
}

resource "hcloud_ssh_key" "ssh_public_key" {
  count = var.provider_name == "hcloud" ? 1 : 0
  provider   = hcloud.default
  name       = var.event_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}