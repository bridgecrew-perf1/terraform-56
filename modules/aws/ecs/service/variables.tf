variable "name" {
  description = ""
  default = ""
}

variable "cluster" {
  description = ""
  default = ""
}

variable "task_definition" {
  description = ""
  default = ""
}

variable "desired_count" {
  description = ""
  default = ""
}

variable "launch_type" {
  description = ""
  default = ""
}

variable "iam_role_arn" {
  description = ""
  default = ""
}

variable "lb" {
  description = ""
  default = ""
}

variable "target_group_name" {
  description = ""
  default = ""
}

variable "port" {
  description = ""
  default = ""
}

/*
Tags
*/
variable "name" {
  description = "Input the name of stack"
  default     = ""
}

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