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
    node         = (
      var.provider_name == "hcloud"   ? hcloud_server.k8s_host[count.index].name :
      var.provider_name == "scaleway" ? scaleway_instance_server.k8s_host[count.index].name :
      count.index
    )
    node_ip      = (
      var.provider_name == "hcloud"   ? hcloud_server.k8s_host[count.index].ipv4_address :
      var.provider_name == "scaleway" ? scaleway_instance_server.k8s_host[count.index].public_ips[0].address :
      ""
    )
    ssh_key_file = local_file.ssh.filename
  })
  filename        = pathexpand("~/.ssh/config.d/k8s${count.index}")
  file_permission = "0644"
}