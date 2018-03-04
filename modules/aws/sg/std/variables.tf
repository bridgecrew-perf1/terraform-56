
variable "description" {
  description = "Description of the security group"
  default = ""
}

variable "vpc_id" {
  description = "The vpc id to create the security group in"
}

variable "igr_from" {
  description = "igr_to"
  default = ""
}

variable "igr_to" {
  description = "igr_to"
  default = ""
}

variable "igr_protocol" {
  description = ""
  default = ""
}

variable "igr_cidr_blocks" {
  description = ""
  type = "list"
  default = []
}

variable "egr_from" {
  description = ""
  default = ""
}

variable "egr_to" {
  description = ""
  default = ""
}

variable "egr_protocol" {
  description = ""
  default = ""
}

variable "egr_cidr_blocks" {
  description = ""
  type = "list"
  default = []
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