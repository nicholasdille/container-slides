variable "event_name" {
  type        = string
  description = "Name of the deployment"
}

variable "seat_count" {
  type        = number
  description = "Number of users to create"
  default     = 1
}

variable "domain" {
  type = string
  description = ""
  default = "inmylab.de"
}

variable "hcloud_location" {
  type = string
  description = ""
  default = "fsn1"
}

variable "hcloud_server_type" {
  type = string
  description = ""
  default = "cx43"
}

variable "hcloud_token" {
  sensitive = true
}

variable "hcloud_dns_token" {
  sensitive = true
}