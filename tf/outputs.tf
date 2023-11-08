output "name" {
  value = "${var.name}"
}

output "dns_name" {
  value = "${hetznerdns_record.main.name}.${data.hetznerdns_zone.main.name}"
}

output "public_ip4" {
  value = "${hcloud_server.vm.ipv4_address}"
}

output "status" {
  value = "${hcloud_server.vm.status}"
}

output "ssh_public_key" {
  value = "${tls_private_key.ssh_private_key.public_key_openssh}"
}

output "certificate" {
  value = "${acme_certificate.certificate.certificate_pem}"
}