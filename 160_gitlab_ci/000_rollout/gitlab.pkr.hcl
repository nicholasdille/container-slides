packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hashicorp/hcloud"
      version = "~> 1"
    }
  }
}

locals {
  gitlab_version = "17.5.1"
  gitlab_runner_version = "17.5.1"
  traefik_version = "3.1.6"
  code_server_version = "4.93.1"
  nginx_version = "1.27.2"
}

source "hcloud" "gitlab" {
  image_filter {
    with_selector = [
      "os-flavor=ubuntu",
      "type=docker"
    ]
    most_recent = true
  }
  location = "nbg1"
  server_type = "cx22"
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
        "docker pull gitlab/gitlab-ee:${local.gitlab_version}-ee.0",
        "docker pull traefik:${local.traefik_version}",
        "docker pull gitlab/gitlab-runner:v${local.gitlab_runner_version}",
        "docker pull codercom/code-server:${local.code_server_version}",
        "docker pull nginx:${local.nginx_version}"
    ]	
  }
}
