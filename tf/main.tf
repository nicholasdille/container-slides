terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "demo" {
  name       = "demo"
  public_key = file("./id_rsa_demo.pub")
}

resource "hcloud_server" "demo" {
  name        = "demo"
  location    = "fsn1"
  image       = "ubuntu-20.04"
  server_type = "cx11"
  ssh_keys = [
    hcloud_ssh_key.demo.id
  ]
  labels = {}
  user_data = <<EOT
#cloud-config

groups:
- user
users:
- name: user
  primary_group: user
  ssh_authorized_keys:
  - ${hcloud_ssh_key.demo.public_key}
  sudo:
  - ALL=(ALL) NOPASSWD:ALL

apt:
  conf: |
    APT {
      Install-Recommends "false";
      Install-Suggests "false";
      Get {
        Assume-Yes "true";
        Fix-Broken "true";
      };
    };

package_update: true
package_upgrade: true
packages:
- bash
- curl
- ca-certificates
- jq
- git
- make

runcmd:
- sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
- curl -fL https://get.docker.com | sh
- sudo -u user env "USER=user" "HOME=/home/user" bash /opt/init_dotfiles.sh

power_state:
  mode: reboot
  delay: now
EOT
}