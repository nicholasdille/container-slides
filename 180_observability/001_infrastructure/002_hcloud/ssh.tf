resource "tls_private_key" "ssh_private_key" {
  algorithm = "ED25519"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "ssh_public_key" {
  provider   = hcloud.default
  name       = var.event_name
  public_key = tls_private_key.ssh_private_key.public_key_openssh
}