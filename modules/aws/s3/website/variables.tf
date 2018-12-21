variable "fqdn" {}

variable "acl" {
  default = "public-read"
}

variable "target_bucket" {}

variable "target_prefix" {}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "404.html"
}

variable "force_destroy" {
  default = false
}
