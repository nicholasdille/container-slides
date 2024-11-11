packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hashicorp/hcloud"
      version = "~> 1"
    }
  }
}

source "hcloud" "uniget" {
  image_filter {
    with_selector = [
      "os-flavor=ubuntu",
      "type=uniget"
    ]
    most_recent = true
  }
  location = "nbg1"
  server_type = "cx22"
  ssh_username = "root"
  snapshot_name = "docker-{{ timestamp }}"
  snapshot_labels = {
    os-flavor = "ubuntu"
    type = "docker"
  }
}

build {
  sources = ["source.hcloud.uniget"]

  provisioner "file" {
    content = <<EOF
APT::Install-Recommends "false";
EOF
    destination = "/etc/apt/apt.conf.d/no-recommends"
  }

  provisioner "file" {
    content = <<EOF
APT::Install-Suggests "false";
EOF
    destination = "/etc/apt/apt.conf.d/no-suggests"
  }

  provisioner "file" {
    source = "uniget.list"
    destination = "/tmp/uniget"
  }

  provisioner "shell" {
    inline = [
        "groupadd --system docker",
        "systemctl daemon-reload",
        "systemctl disable docker.service",
        "systemctl enable docker.socket", "systemctl start docker.socket",
        "while ! docker version; do sleep 2; done"
    ]	
  }
}
