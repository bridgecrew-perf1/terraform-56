variable "region" {}

variable "role_arn" {}

variable "name" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "instance_type" {}


variable "env" {}

variable "account" {}

variable "vpc_zone_identifier" {
  type = "list"
}

variable "security_group" {
  type = "list"
}

variable "autoscaling_enabled" {}

variable "sns_enabled" {}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "other_tags" {
  description = "For adding an additional values for tags"
  type = "map"
  default = {}
}