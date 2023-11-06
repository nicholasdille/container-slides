output "public_ip4" {
  value = "${hcloud_server.demo.ipv4_address}"
}

output "status" {
  value = "${hcloud_server.demo.status}"
}

output "public_key" {
  value = "${tls_private_key.demo.public_key_openssh}"
}