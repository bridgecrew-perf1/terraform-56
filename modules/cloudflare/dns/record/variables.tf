variable "zone_id" {}

variable "name" {}

variable "value" {}

variable "type" { default = "CNAME" }

variable "ttl" { default = 3600 }

variable "proxied" { default = false }
