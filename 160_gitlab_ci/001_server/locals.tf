locals {
  domain           = "inmylab.de"
  seats_json_file  = jsondecode(file("../000_rollout/seats.json"))
  seats_password   = local.seats_json_file.seats[*].password
  grafana_password = local.seats_json_file.gitlab_admin_password
}