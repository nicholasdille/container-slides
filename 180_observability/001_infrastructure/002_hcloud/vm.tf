data "hcloud_image" "packer" {
  provider      = hcloud.default
  with_selector = "type=gitlab"
  most_recent   = true
}

resource "hcloud_server" "k8s_host" {
  count = var.seat_count

  provider    = hcloud.default
  name        = "k8s_${count.index}"
  location    = var.hcloud_location
  server_type = var.hcloud_server_type
  image       = data.hcloud_image.packer.id
  ssh_keys = [
    hcloud_ssh_key.ssh_public_key.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.event_name
  }
}

resource "null_resource" "wait_for_ssh" {
  count = var.seat_count

  provisioner "remote-exec" {
    connection {
      host        = hcloud_server.k8s_host[index].ipv4_address
      user        = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}