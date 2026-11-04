data "scaleway_instance_image" "packer" {
  name = "uniget-docker"
}

resource "scaleway_iam_ssh_key" "ssh_public_key" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  name       = var.event_name
  project_id = var.scaleway_project_id
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

resource "scaleway_instance_ip" "public_ip" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  project_id = var.scaleway_project_id
}

resource "scaleway_block_volume" "data" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  project_id = var.scaleway_project_id
  size_in_gb = 50
  iops       = 5000
}

resource "scaleway_instance_security_group" "www" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  project_id              = var.scaleway_project_id
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = "22"
    ip_range = "0.0.0.0/0"
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }

  inbound_rule {
    action = "accept"
    port   = "6443"
  }
}

resource "scaleway_instance_server" "k8s_host" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  project_id = var.scaleway_project_id
  type       = var.scaleway_server_type
  image      = data.scaleway_instance_image.packer.id

  tags = [
    var.event_name
  ]

  ip_id = scaleway_instance_ip.public_ip[count.index].id

  additional_volume_ids = [scaleway_block_volume.data[count.index].id]

  root_volume {
    size_in_gb = 50
  }

  security_group_id = scaleway_instance_security_group.www[count.index].id
}

resource "null_resource" "scw_wait_for_ssh" {
  count = var.provider_name == "scaleway" ? var.seat_count : 0

  provisioner "remote-exec" {
    connection {
      host        = scaleway_instance_server.k8s_host[count.index].public_ips[0].address
      user        = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}