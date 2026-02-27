#resource "ssh_resource" "example" {
#  host         = "remote-server.test"
#  user         = "alpine"
#  agent        = true
#
#  when         = "create" # Default
#
#  file {
#    content     = "echo '{\"hello\":\"world\"}' && exit 0"
#    destination = "/home/alpine/test.sh"
#    permissions = "0700"
#  }
#
#  commands = [
#    "/home/alpine/test.sh",
#  ]
#}