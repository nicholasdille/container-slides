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

resource "hcloud_server" "vm" {
  name        = var.name
  location    = local.location
  server_type = local.server_type
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

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "${var.name}.${local.domain}"
  subject_alternative_names = [
    "*.${var.name}.${local.domain}"
  ]

  dns_challenge {
    provider = "hetzner"

    config = {
      HETZNER_API_KEY = var.hetznerdns_token
    }
  }
}

# TODO: https://stackoverflow.com/a/62407671
resource "null_resource" "wait_for_ssh" {
  provisioner "remote-exec" {
    connection {
      host = hcloud_server.vm.ipv4_address
      user = "root"
      private_key = tls_private_key.ssh_private_key.private_key_openssh
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command = <<EOF
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
  echo -e "\033[1;36mWaiting for cloud-init..."
  sleep 2
done
EOF
  }
}

resource "remote_file" "tls_key" {
  conn {
    host        = hcloud_server.vm.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.key"
  content     = acme_certificate.certificate.private_key_pem
  permissions = "0600"
}

resource "remote_file" "tls_crt" {
  conn {
    host        = hcloud_server.vm.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.crt"
  content     = acme_certificate.certificate.certificate_pem
  permissions = "0644"
}

resource "remote_file" "tls_chain" {
  conn {
    host        = hcloud_server.vm.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.chain"
  content     = acme_certificate.certificate.issuer_pem
  permissions = "0644"
}

data "hetznerdns_zone" "main" {
  name = local.domain
}

resource "hetznerdns_record" "main" {
  zone_id = data.hetznerdns_zone.main.id
  name = var.name
  value = hcloud_server.vm.ipv4_address
  type = "A"
  ttl= 120
}

resource "hetznerdns_record" "wildcard" {
  zone_id = data.hetznerdns_zone.main.id
  name = "*.${var.name}"
  value = hetznerdns_record.main.name
  type = "CNAME"
  ttl= 120
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

resource "local_file" "ssh_config_file" {
  content = templatefile("ssh_config.tpl", {
    node = var.name,
    node_ip = hcloud_server.vm.ipv4_address
    ssh_key_file = local_file.ssh.filename
  })
  filename = pathexpand("~/.ssh/config.d/${var.name}")
  file_permission = "0644"
}

resource "remote_file" "vars" {
  conn {
    host        = hcloud_server.vm.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path = "/etc/profile.d/vars.sh"
  content = <<EOF
export SEAT_USER="${var.name}"
export SEAT_INDEX="${var.index}"
export SEAT_PASS="${var.password}"
export SEAT_HTPASSWD="$(htpasswd -nbB seat "$${SEAT_PASS}" | sed -e 's/\$/\\\$/g')"
export SEAT_HTPASSWD_ONLY="$(echo "$${SEAT_HTPASSWD}" | cut -d: -f2)"
export SEAT_CODE="${var.code}"
export SEAT_CODE_HTPASSWD="$(htpasswd -nbB seat "$${SEAT_CODE}" | sed -e 's/\$/\\\$/g')"
export DOMAIN="${var.name}.${local.domain}"
export IP="${hcloud_server.vm.ipv4_address}"
export WEBDAV_PASS_DEV="${var.webdav_pass_dev}"
export WEBDAV_PASS_LIVE="${var.webdav_pass_live}"
export GITLAB_ADMIN_PASS="${var.gitlab_admin_password}"
export GITLAB_ADMIN_TOKEN="${var.gitlab_admin_token}"
EOF
  permissions = "0755"
}

resource "remote_file" "bootstrap_sh" {
  conn {
    host        = hcloud_server.vm.ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/opt/bootstrap.sh"
  content = file("bootstrap.sh")
  permissions = "0700"
}

resource "ssh_resource" "bootstrap" {
  count = 0
  depends_on = [
    remote_file.vars,
    remote_file.bootstrap_sh
  ]
  when = "create"
  host = hcloud_server.vm.ipv4_address
  user = "root"
  private_key = tls_private_key.ssh_private_key.private_key_openssh
  timeout = "2m"
  retry_delay = "5s"
  commands = [
    remote_file.bootstrap_sh.path
  ]
}

#provider "gitlab" {
#  token = var.gitlab_admin_token
#  base_url = "https://gitlab.${var.name}.${local.domain}/api/v4/"
#}
#
#resource "gitlab_user" "seat" {
#  depends_on = [
#    ssh_resource.bootstrap
#  ]
#  name              = "Seat User"
#  username          = var.user
#  password          = var.password
#  email             = "gitlab@user.create"
#  skip_confirmation = true
#}
#
#resource "gitlab_personal_access_token" "seat" {
#  user_id    = gitlab_user.seat.id
#  name       = "seat"
#  expires_at = "2023-12-31"
#
#  scopes = [
#    "api",
#    "read_user",
#    "write_repository"
#  ]
#}