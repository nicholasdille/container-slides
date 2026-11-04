packer {
  required_plugins {
    hcloud = {
      # https://github.com/hetznercloud/packer-plugin-hcloud  
      source  = "github.com/hetznercloud/hcloud"
      version = "1.8.2"
    }
    scaleway = {
      # https://github.com/scaleway/packer-plugin-scaleway
      source  = "github.com/scaleway/scaleway"
      version = "1.5.0"
    }
  }
}

source "hcloud" "uniget" {
  image = "ubuntu-26.04"
  location = "nbg1"
  server_type = "cx23"
  ssh_username = "root"
  snapshot_name = "docker-{{ timestamp }}"
  snapshot_labels = {
    os-flavor = "ubuntu"
    type = "docker"
  }
}

source "scaleway" "uniget" {
  image_name = "uniget-docker"
  image = "ubuntu_resolute"
  zone = "fr-par-1"
  commercial_type = "DEV1-S"
  ssh_username = "root"
  tags = [
    "ubuntu",
    "docker"
  ]
}

build {
  sources = [
    "source.hcloud.uniget",
    "source.scaleway.uniget"
  ]

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
    destination = "/tmp/uniget.list"
  }

  provisioner "shell" {
    inline = [
        "apt-get update",
        "apt-get -y upgrade",
        "apt-get -y install curl ca-certificates git",
        "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"systemd.unified_cgroup_hierarchy=1\"/' /etc/default/grub",
        "update-grub",
        "curl -sLf \"https://gitlab.com/uniget-org/cli/-/releases/permalink/latest/downloads/uniget_Linux_$(uname -m).tar.gz\" | tar -xzC /usr/local/bin uniget",
        "uniget update",
        "uniget install --file /tmp/uniget.list",
        "rm /tmp/uniget.list",
        "cp /usr/local/etc/systemd/system/docker.socket /etc/systemd/system/",
        "cp /usr/local/etc/systemd/system/docker.service /etc/systemd/system/",
        "groupadd --system docker",
        "systemctl daemon-reload",
        "systemctl disable docker.service",
        "systemctl enable docker.socket",
        "systemctl start docker.socket",
        "while ! docker version; do sleep 2; done"
    ]	
  }
}
