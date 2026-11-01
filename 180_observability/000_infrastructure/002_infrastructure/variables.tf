variable "event_name" {
  type        = string
  description = "Name of the deployment"
}

variable "seat_count" {
  type        = number
  description = "Number of users to create"
  default     = 2
}

variable "domain" {
  type        = string
  description = ""
  default     = "inmylab.de"
}

variable "create_dns" {
  type = bool
  description = ""
  default = true
}

variable "create_tls" {
  type = bool
  description = ""
  default = true
}

variable "acme_staging" {
  type    = bool
  default = true
}

variable "provider_name" {
  type = string
  description = ""
  default = "scaleway"
}

variable "hcloud_location" {
  type        = string
  description = ""
  default     = "hel1"
}

variable "hcloud_server_type" {
  type        = string
  description = ""
  default     = "cx43"
}

variable "hcloud_token" {
  sensitive = true
}

variable "hcloud_dns_token" {
  sensitive = true
}

variable "scaleway_project_id" {
  type = string
  description = ""
}

variable "scaleway_location" {
  type        = string
  description = ""
  default     = "fr-par-1"
}

variable "scaleway_server_type" {
  type        = string
  description = ""
  default     = "BASIC2-A8C-16G"    # https://www.scaleway.com/en/pricing/virtual-instances/?ram=8|16&cpu=4|8&cpu_type=shared
}

variable "scaleway_image_uuid" {
  type = string
  description = ""
  default = "ubuntu_resolute"
}

variable "scaleway_token" {
  sensitive = true
}