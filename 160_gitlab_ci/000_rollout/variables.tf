variable name {
  type = string
}

variable user {
  type = string
  default = "seat"
}

variable index {
  type = string
  default = "0"
}

variable password {
  type = string
  default = "Start123!"
  sensitive = true
}

variable code {
  type = string
  default = "A1B2C3"
  sensitive = true
}

variable webdav_pass_dev {
  type = string
  default = "Start123!dev"
  sensitive = true
}

variable webdav_pass_live {
  type = string
  default = "Start123!live"
  sensitive = true
}

variable gitlab_admin_password {
  type = string
  default = "Start123!"
  sensitive = true
}

variable gitlab_admin_token {
  type = string
  default = "Start123!"
  sensitive = true
}

variable "hcloud_token" {
  sensitive = true
}

variable "hetznerdns_token" {
  sensitive = true
}