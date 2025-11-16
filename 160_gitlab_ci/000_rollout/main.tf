provider "hcloud" {
  token = var.hcloud_token
}

provider "hetznerdns" {
  apitoken = var.hetznerdns_token
}

provider "acme" {
  #server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "ssh_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ssh_public_key" {
  name       = var.name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}

data "hcloud_image" "packer" {
  with_selector = "type=gitlab"
  most_recent = true
}

resource "hcloud_server" "gitlab" {
  name        = "gitlab"
  location    = local.location_gitlab
  server_type = local.server_type_gitlab
  image       = data.hcloud_image.packer.id
  ssh_keys    = [
    hcloud_ssh_key.ssh_public_key.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.name
  }
}

resource "hcloud_server" "runner" {
  name        = "runner"
  location    = local.location_runner
  server_type = local.server_type_runner
  image       = data.hcloud_image.packer.id
  ssh_keys    = [
    hcloud_ssh_key.ssh_public_key.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.name
  }
}

resource "hcloud_server" "vscode" {
  name        = "vscode"
  location    = local.location_vscode
  server_type = local.server_type_vscode
  image       = data.hcloud_image.packer.id
  ssh_keys    = [
    hcloud_ssh_key.ssh_public_key.name
  ]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "purpose" : var.name
  }
}

resource "tls_private_key" "certificate" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.certificate.private_key_pem
  email_address   = "webmaster@${local.domain}"
}

resource "acme_certificate" "gitlab" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "gitlab.${local.domain}"
  subject_alternative_names = [
    "traefik.${local.domain}",
    "code.${local.domain}",
    "*.dev.webdav.${local.domain}",
    "*.live.webdav.${local.domain}",
    "gitlab.${local.domain}",
    "*.gitlab.${local.domain}",
    "grafana.${local.domain}"
  ]

  dns_challenge {
    provider = "hetzner"

    config = {
      HETZNER_API_KEY = var.hetznerdns_token
    }
  }
}

resource "acme_certificate" "vscode" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "vscode.${local.domain}"
  subject_alternative_names = [
    "*.vscode.${local.domain}"
  ]

  dns_challenge {
    provider = "hetzner"

    config = {
      HETZNER_API_KEY = var.hetznerdns_token
    }
  }
}

resource "null_resource" "wait_for_ssh_gitlab" {
  provisioner "remote-exec" {
    connection {
      host = hcloud_server.gitlab.ipv4_address
      user = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}

resource "null_resource" "wait_for_ssh_runner" {
  provisioner "remote-exec" {
    connection {
      host = hcloud_server.runner.ipv4_address
      user = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}

resource "null_resource" "wait_for_ssh_vscode" {
  provisioner "remote-exec" {
    connection {
      host = hcloud_server.vscode.ipv4_address
      user = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }
}

resource "remote_file" "tls_key_gitlab" {
  conn {
    host        = hcloud_server.gitlab.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.key"
  content     = acme_certificate.gitlab.private_key_pem
  permissions = "0600"
}

resource "remote_file" "tls_crt_gitlab" {
  conn {
    host        = hcloud_server.gitlab.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.crt"
  content     = acme_certificate.gitlab.certificate_pem
  permissions = "0644"
}

resource "remote_file" "tls_chain_gitlab" {
  conn {
    host        = hcloud_server.gitlab.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.chain"
  content     = acme_certificate.gitlab.issuer_pem
  permissions = "0644"
}

resource "remote_file" "tls_key_vscode" {
  conn {
    host        = hcloud_server.vscode.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.key"
  content     = acme_certificate.vscode.private_key_pem
  permissions = "0600"
}

resource "remote_file" "tls_crt_vscode" {
  conn {
    host        = hcloud_server.vscode.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.crt"
  content     = acme_certificate.vscode.certificate_pem
  permissions = "0644"
}

resource "remote_file" "tls_chain_vscode" {
  conn {
    host        = hcloud_server.vscode.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.chain"
  content     = acme_certificate.vscode.issuer_pem
  permissions = "0644"
}

data "hcloud_zone" "main" {
  provider = hcloud.dns
  name = local.domain
}

resource "hcloud_zone_rrset" "gitlab" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "gitlab"
  type = "A"
  ttl= 120
  records = [
    { value = hcloud_server.gitlab.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "grafana" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "grafana"
  type = "A"
  ttl= 120
  records = [
    { value = hcloud_server.gitlab.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "gitlab_wildcard" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "*.gitlab"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.gitlab.name },
  ]
}

resource "hcloud_zone_rrset" "gitlab_traefik" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "traefik"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.gitlab.name },
  ]
}

resource "hcloud_zone_rrset" "gitlab_code" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "code"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.gitlab.name },
  ]
}

resource "hcloud_zone_rrset" "webdav_dev" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "dev.webdav"
  type = "A"
  ttl= 120
  records = [
    { value = hcloud_server.gitlab.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "webdav_dev_wildcard" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "*.dev.webdav"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.webdav_dev.name },
  ]
}

resource "hcloud_zone_rrset" "webdav_live" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "live.webdav"
  type = "A"
  ttl= 120
  records = [
    { value = hcloud_server.gitlab.ipv4_address
}

resource "hcloud_zone_rrset" "webdav_live_wildcard" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "*.live.webdav"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.webdav_live.name },
  ]
}

resource "hcloud_zone_rrset" "vscode" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "vscode"
  type = "A"
  ttl= 120
  records = [
    { value = hcloud_server.vscode.ipv4_address },
  ]
}

resource "hcloud_zone_rrset" "vscode_wildcard" {
  provider = hcloud.dns
  zone_id = data.hcloud_zone.main.name
  name = "*.vscode"
  type = "CNAME"
  ttl= 120
  records = [
    { value = hcloud_zone_rrset.vscode.name },
  ]
}

resource "local_file" "ssh" {
  content = tls_private_key.ssh_private_key.private_key_openssh
  filename = pathexpand("~/.ssh/${var.name}_ssh")
  file_permission = "0600"
}

resource "local_file" "ssh_pub" {
  content = tls_private_key.ssh_private_key.public_key_openssh
  filename = pathexpand("~/.ssh/${var.name}_ssh.pub")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file_gitlab" {
  content = templatefile("ssh_config.tpl", {
    node = hcloud_server.gitlab.name,
    node_ip = hcloud_server.gitlab.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/gitlab")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file_runner" {
  content = templatefile("ssh_config.tpl", {
    node = hcloud_server.runner.name,
    node_ip = hcloud_server.runner.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/runner")
  file_permission = "0644"
}

resource "local_file" "ssh_config_file_vscode" {
  content = templatefile("ssh_config.tpl", {
    node = hcloud_server.vscode.name,
    node_ip = hcloud_server.vscode.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/vscode")
  file_permission = "0644"
}
