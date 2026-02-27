resource "tls_private_key" "certificate" {
  count = var.seat_count

  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.certificate.private_key_pem
  email_address   = "webmaster@${var.domain}"
}

resource "acme_certificate" "k8s" {
  count = var.seat_count

  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = "seat${count.index}.k8s.${var.domain}"
  subject_alternative_names = [
    "seat${count.index}.k8s.${var.domain}",
    "*.seat${count.index}.k8s.${var.domain}"
  ]

  dns_challenge {
    provider = "hetzner"

    config = {
      HETZNER_API_TOKEN = var.hcloud_dns_token
    }
  }
}

resource "remote_file" "tls_key" {
  count = var.seat_count

  conn {
    host        = hcloud_server.k8s_host[index].ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.key"
  content     = acme_certificate.k8s[index].private_key_pem
  permissions = "0600"
}

resource "remote_file" "tls_crt" {
  count = var.seat_count

  conn {
    host        = hcloud_server.k8s_host[index].ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.crt"
  content     = acme_certificate.k8s[index].certificate_pem
  permissions = "0644"
}

resource "remote_file" "tls_chain_gitlab" {
  count = var.seat_count

  conn {
    host        = hcloud_server.k8s_host[index].ipv4_address
    port        = 22
    user        = "root"
    private_key = tls_private_key.ssh_private_key.private_key_openssh
  }

  path        = "/etc/ssl/tls.chain"
  content     = acme_certificate.k8s[index].issuer_pem
  permissions = "0644"
}