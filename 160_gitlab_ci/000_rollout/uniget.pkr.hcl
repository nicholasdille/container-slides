packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hashicorp/hcloud"
      version = "~> 1"
    }
  }
}

source "hcloud" "uniget" {
  image = "ubuntu-24.04"
  location = "nbg1"
  server_type = "cx11"
  ssh_username = "root"
  snapshot_name = "uniget-{{ timestamp }}"
  snapshot_labels = {
    os-flavor = "ubuntu"
    type = "uniget"
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
        "apt-get update", "apt-get -y upgrade",
        "apt-get -y install curl ca-certificates git apache2-utils",
        "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"systemd.unified_cgroup_hierarchy=1\"/' /etc/default/grub", "update-grub",
        "curl -sLf https://github.com/uniget-org/cli/releases/latest/download/uniget_linux_$(uname -m).tar.gz | tar -xzC /usr/local/bin uniget",
        "uniget update", "uniget install --file /tmp/uniget", "rm /tmp/uniget",
        "while ! docker version; do sleep 2; done"
    ]	
  }
}
