data "hcloud_zone" "main" {
  provider = hcloud.dns
  name     = var.domain
}

resource "hcloud_zone_rrset" "k8s_host" {
  count = var.create_dns ? var.seat_count : 0

  provider = hcloud.dns
  zone     = data.hcloud_zone.main.name
  name     = "seat${count.index}"
  type     = "A"
  ttl      = 120
  records = [
    { 
      value = (
        var.provider_name == "hcloud"   ? hcloud_server.k8s_host[count.index].ipv4_address : 
        var.provider_name == "scaleway" ? scaleway_instance_server.k8s_host[count.index].public_ips[0].address :
        ""
      ),
    },
  ]
}

resource "hcloud_zone_rrset" "k8s_host_wildcard" {
  count = var.create_dns ? var.seat_count : 0

  provider = hcloud.dns
  zone     = data.hcloud_zone.main.name
  name     = "*.seat${count.index}"
  type     = "CNAME"
  ttl      = 120
  records = [
    { value = hcloud_zone_rrset.k8s_host[count.index].name },
  ]
}