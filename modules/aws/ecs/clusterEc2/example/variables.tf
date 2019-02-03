variable "region" {}

variable "role_arn" {}

variable "name" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "instance_type" {}

variable "tag_costcenter" {}

variable "tag_project" {}

variable "tag_modifiedby" {}

variable "tag_modifydate" {}

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