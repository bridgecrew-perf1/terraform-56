variable "name" {
  description = "The name to put on the tag"
  default = ""
}

variable "description" {
  description = "Explain the key usage etc"
  default = ""
}

variable "policy" {
  description = "The policy document"
  default = ""
}

variable "is_enabled" {
  description = "Boolean, should only be set to false if there is concern about it's integrity"
  default = ""
}

variable "key_alias" {
  description = "Key alias to used as a data source"
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