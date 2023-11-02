output "public_ip4" {
  value = "${hcloud_server.demo.ipv4_address}"
}

output "status" {
  value = "${hcloud_server.demo.status}"
}