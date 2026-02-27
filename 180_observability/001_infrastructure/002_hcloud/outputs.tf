output "ssh_private_key" {
  value = tls_private_key.ssh_private_key.private_key_openssh
  sensitive = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh_private_key.public_key_openssh
}

output "ipv4_addresses" {
  value = hcloud_server.k8s_host[*].ipv4_address
}

output "tls_keys" {
  value = tls_private_key.certificate[*].private_key_pem
  sensitive = true
}

output "tls_certificates" {
  value = acme_certificate.k8s[*].certificate_pem
}