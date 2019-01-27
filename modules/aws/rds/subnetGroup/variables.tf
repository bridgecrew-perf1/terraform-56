variable "name" {
  description = "The name of the subnet group"
  default = ""
}

variable "subnet_ids" {
  description = "The chosen VPC subnet is to use for the RDS"
  type = "list"
  default = []
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
