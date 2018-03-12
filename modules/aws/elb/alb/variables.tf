variable "name" {
  description = "Input the name of stack"
  default     = ""
}

variable "internal" {
  description = "Boolean, set the type of ip for the LB"
  default = ""
}

variable "load_balancer_type" {
  description = "Set the App lb type, can be application or network"
  default = ""
}

variable "security_groups" {
  description = "The security group(s) of the LB"
  type = "list"
  default = []
}

variable "subnets" {
  description = "The subnets to listen from"
  type = "list"
  default = []
}

variable "enable_deletion_protection" {
  description = "Boolean, useful if you have multiple targets - avoids wide spread impact if deleted"
  default = ""
}

variable "log_bucket" {
  description = "The bucket to store the access logs"
  default = ""
}

variable "bucket_prefix" {
  description = "The prefix key to use on the log files"
  default = ""
}

/*
Tags
*/

variable "tag_project" {
  description = "The name of the project this resource belongs to"
  default     = ""
}

variable "tag_env" {
  description = "The environemnt this resource is being deployed to"
  default     = ""
}

variable "tag_costcenter" {
  description = "The cost center"
  default     = ""
}

variable "tag_createdby" {
  description = "Who created this resource"
  default     = ""
}