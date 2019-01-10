variable "cloudflare_zone" {}

variable "target" {}

variable "priority" {}

variable "status" {
  default = "active"
}

variable "ssl_action" {
  default = "full"
}
