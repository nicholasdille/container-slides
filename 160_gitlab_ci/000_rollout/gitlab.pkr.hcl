packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hashicorp/hcloud"
      version = "~> 1"
    }
  }
}

locals {
  gitlab_version = "16.9.1"
  gitlab_runner_version = "16.9.1"
  traefik_version = "2.10.7"
  portainer_version = "2.19.4"
  code_server_version = "4.23.0"
  nginx_version = "1.24.0"
}

source "hcloud" "gitlab" {
  image_filter {
    with_selector = [
      "os-flavor=ubuntu",
      "type=uniget"
    ]
    most_recent = true
  }
  location = "nbg1"
  server_type = "cx11"
  ssh_username = "root"
  snapshot_name = "gitlab-{{ timestamp }}"
  snapshot_labels = {
    os-flavor = "ubuntu"
    type = "gitlab"
  }
}

build {
  sources = ["source.hcloud.gitlab"]

  provisioner "shell" {
    inline = [
        "docker pull gitlab/gitlab-ee:${local.gitlab_version}-ce.0",
        "docker pull traefik:${local.traefik_version}",
        "docker pull portainer/portainer-ce:${local.portainer_version}-alpine",
        "docker pull gitlab/gitlab-runner:v${local.gitlab_runner_version}",
        "docker pull codercom/code-server:${local.code_server_version}",
        "docker pull nginx:${local.nginx_version}"
    ]	
  }
}
