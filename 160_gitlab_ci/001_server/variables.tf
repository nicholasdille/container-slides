variable "name" {
  type        = string
  description = "Name of the deployment"
}

variable "gitlab_token" {
  type        = string
  description = "Admin token to manage the instance"
  sensitive   = true
}

variable "user_count" {
  type        = number
  description = "Number of users to create"
  default     = 1
}