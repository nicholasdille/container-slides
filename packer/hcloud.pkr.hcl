packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hashicorp/hcloud"
      version = "~> 1"
    }
  }
}

locals {
  gitlab_version = "16.5.1"
  gitlab_runner_version = "16.5.0"
  traefik_version = "2.10.5"
  portainer_version = "2.19.1"
  code_server_version = "4.18.0"
  nginx_version = "1.24.0"
}

source "hcloud" "uniget" {
  image = "ubuntu-22.04"
  #image_filter {
  #  with_selector = [ "os_flavor=ubuntu" ]
  #  most_recent = true
  #}
  location = "nbg1"
  server_type = "cx11"
  ssh_username = "root"
  snapshot_name = "uniget-{{ timestamp }}"
}

build {
  sources = ["source.hcloud.uniget"]

  provisioner "file" {
    source = "uniget"
    destination = "/tmp/uniget"
  }

  provisioner "shell" {
    inline = [
        "curl -sLf https://github.com/uniget-org/cli/releases/latest/download/uniget_linux_$(uname -m).tar.gz | tar -xzC /usr/local/bin uniget",
        "uniget update", "uniget install --file /tmp/uniget", "rm /tmp/uniget",
        "while ! docker version; do sleep 2; done",
        "docker pull gitlab/gitlab-ce:${local.gitlab_version}-ce.0",
        "docker pull traefik:${local.traefik_version}",
        "docker pull portainer/portainer-ce:${local.portainer_version}-alpine",
        "docker pull gitlab/gitlab-runner:v${local.gitlab_runner_version}",
        "docker pull codercom/code-server:${local.code_server_version}",
        "docker pull nginx:${local.nginx_version}"
    ]	
  }
}
