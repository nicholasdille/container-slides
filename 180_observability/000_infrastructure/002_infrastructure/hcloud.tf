resource "hcloud_ssh_key" "ssh_public_key" {
  count = var.provider_name == "hcloud" ? 1 : 0

  provider   = hcloud.default
  name       = var.event_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

data "hcloud_image" "packer" {
  count = var.provider_name == "hcloud" ? 1 : 0

  provider      = hcloud.default
  with_selector = "type=docker"
  most_recent   = true
}

resource "hcloud_server" "k8s_host" {
  count = var.provider_name == "hcloud" ? var.seat_count : 0

  provider    = hcloud.default
  name        = "k8s${count.index}"
  location    = var.hcloud_location
  server_type = var.hcloud_server_type
  image       = data.hcloud_image.packer[0].id
  ssh_keys = [
    hcloud_ssh_key.ssh_public_key[0].name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.event_name
  }
}

resource "null_resource" "hcloud_wait_for_ssh" {
  count = var.provider_name == "hcloud" ? var.seat_count : 0

  provisioner "remote-exec" {
    connection {
      host        = hcloud_server.k8s_host[count.index].ipv4_address
      user        = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}